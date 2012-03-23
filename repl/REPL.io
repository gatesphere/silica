// silica programming language
// Jacob M. Peck
// REPL proto

if(?REPL_DEBUG, writeln("  + Loading REPL.io"))

silica REPL REPL := Object clone do(
  rl := ReadLine
  
  currentNamespace := silica namespace("home")
  
  mcmode := false
  silent := false
  
  parser := silica REPL Parser
  
  siren_in_path := Path with(SILICA_DIR,"siren","siren_in")
  siren_out_path := Path with(SILICA_DIR,"siren","siren_out")
  siren_midi_path := Path with(SILICA_DIR,"siren","midi")
  
  clone := method(self)
  
  initialize := method(
    self rl prompt = "silica> "
    self
  )
  
  // loads the history
  loadHistory := method(
    try (
      if(SILICA_DIR != nil,
        self rl loadHistory(Path with(SILICA_DIR, ".silica_history"))
        ,
        self rl loadHistory(".silica_history")
      )
    )
  )
  
  // saves the history
  saveHistory := method(
    try (
      if(SILICA_DIR != nil,
        self rl saveHistory(Path with(SILICA_DIR, ".silica_history"))
        ,
        self rl saveHistory(".silica_history")
      )
    )
  )
  
  // runs the whole thing
  run := method(script, autoexec,
    if(script != nil,
      // scripting mode
      file := File with(script)
      if(file exists not,
        writeln("Cannot run script \"" .. file path .. "\".  No such file.")
        silica exit = true;
        break
      )
      file := File with(script) openForReading
      if(autoexec == nil, writeln("Running script \"" .. file path .. "\".\n"))
      loop(
        in := file readLine
        if(in == nil, 
          if(autoexec == nil, silica exit = true) // exit after a script, but not after autoexec
          break
        )
        if(in strip == "",
          continue
        )
        if(in strip beginsWithSeq("##") not, // lines beginning with ## are comments
          self interpretLine(in)
        )
      )
      file close
      ,
      // interactive mode
      loop(
        in := self rl readLine(self rl prompt);
        self rl addHistory(in);
        self interpretLine(in);
        if(silica exit, 
          self saveHistory;
          break
        )
      )
    )
  )
  
  interpretLine := method(in,
    out := list(list("-->", nil))
    vol := "$" .. silica Note volume
    inst := "@" .. silica Note instrument name
    
    processed := self parser preprocess(in, self)
    if(processed == nil,
      if(self silent not, writeln)
      return
    )
    if(?REPL_DEBUG, writeln("TRACE (interpretLine) received: " .. processed))
    
    transformed := self parser applyTransforms(processed)
    if(?REPL_DEBUG, writeln("TRACE (interpretLine) received: " .. processed))
    
    transformed splitNoEmpties foreach(tok,
      ret := self parser interpretToken(tok asMutable lowercase, true, self currentNamespace, self)
      if(ret first != nil, out append(ret first))
    )
    if(?REPL_DEBUG, writeln("TRACE (interpretLine) out = " .. out))
    
    repl_out := out map(tok, tok first) remove(nil)
    siren_out := out map(tok, tok second) remove(nil)
    
    if(siren_out size != 0, siren_out prepend(inst) prepend(vol) prepend("!" .. silica Note tempo))
    if(?REPL_DEBUG, writeln("TRACE (interpretLine): siren_out = " .. siren_out))
    if(REPL_SIREN_ENABLED,
      if(siren_out size != 0,
        self writeToSiren(siren_out prepend("render-sonic\n") join(" ") strip)
      )
    )
    if(repl_out size == 1, repl_out append("okay."))
    if(silent not, writeln(repl_out join(" ") strip))
  )
  
  writeToSiren := method(string,
    if(string == "",return nil)
    
    file := File with(Path with(siren_in_path,UUID uuidRandom .. ".siren")) openForUpdating
    if(?REPL_DEBUG, writeln("Sending to siren: " .. file path .. " " .. string))
    file write(string)
    file close
    
    nil
  )
    
  readFromSiren := method() // to be done
)
