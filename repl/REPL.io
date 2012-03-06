// silica programming language
// Jacob M. Peck
// REPL proto

if(?REPL_DEBUG, writeln("  + Loading REPL.io"))

silica REPL REPL := Object clone do(
  rl := ReadLine
  
  currentNamespace := silica namespace("home")
  
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
  run := method(script,
    if(script != nil,
      // scripting mode
      file := File with(script)
      if(file exists not,
        writeln("Cannot run script \"" .. file path .. "\".  No such file.")
        silica exit = true;
        break
      )
      file := File with(script) openForReading
      writeln("Running script \"" .. file path .. "\".\n\n")
      loop(
        in := file readLine
        if(in == nil,
          silica exit = true;
          break
        )
        if(in strip == "",
          continue
        )
        parse(in)
      )
      file close
      ,
      // interactive mode
      loop(
        in := self rl readLine(self rl prompt);
        self rl addHistory(in);
        parse(in);
        if(silica exit, 
          self saveHistory;
          break
        )
      )
    )
  )
  
  writeToSiren := method(string,
    if(string == "",return nil)
    //try(
      file := File with(Path with(siren_in_path,UUID uuidRandom)) openForUpdating
      if(?REPL_DEBUG, writeln("Sending to siren: " .. file path))
      file write(string)
      file close
    //)
    nil
  )
    
  readFromSiren := method() // to be done
  
  // parsing tokens, one by one
  parse := method(in,
    processed := self preprocess(in)
    out := list(list("-->", nil))
    vol := "$" .. silica Note volume
    if(processed == nil,
      writeln
      return
    )
    if(?REPL_DEBUG, writeln("TRACE (parse) received: " .. processed))
    transformed := self applyTransforms(processed)
    transformed splitNoEmpties foreach(tok,
      ret := self interpretToken(tok asMutable lowercase, true, self currentNamespace)
      if(ret first != nil, out append(ret first))
    )
    repl_out := out map(tok, tok first) remove(nil)
    siren_out := out map(tok, tok second) remove(nil)
    if(out size == 1, out append("okay"))
    if(siren_out size != 0, siren_out prepend(vol) prepend("!" .. silica Note tempo))
    if(?REPL_DEBUG, writeln("TRACE (parse): siren_out = " .. siren_out))
    if(REPL_SIREN_ENABLED, 
      self writeToSiren(siren_out join(" ") strip)
    ) 
    writeln(repl_out join(" ") strip)
  )
  
  validName := method(name,
    out := true
    if(name findSeqs(list("(",")",":","=","+", "-",",")) != nil, out = false)
    symbol := silica token(silica namespace("home"), name lowercase)
    if(symbol isKindOf(silica Primitive) or symbol isKindOf(silica MetaCommand) or symbol isKindOf(silica Transform),
      out := false
    )
    out
  )
    
  
  // get the input to be all primitives
  preprocess := method(in,
    out := in splitNoEmpties
    
    // macro definition?
    if(out at(1) == ">>",
      name := out at(0)
      if(self validName(name) not,
        write("--> MACRO name is invalid.")
        ,
        contents := out rest rest join(" ")
        if(name asNumber isNan,
          m := silica Macro with(name uppercase, contents)
          silica TokenTable add(self currentNamespace, 
                                name lowercase, 
                                m
          )
          write("--> MACRO " .. self currentNamespace constructName .. "::" .. name uppercase .. " defined.")
          ,
          write("--> MACRO names cannot begin with numbers.")
        )
      )
      return nil
    )
    
    // command definition?
    if(out at(1) == "=", 
      name := out at(0)
      if(self validName(name) not,
        write("--> COMMAND name is invalid.")
        ,
        contents := out rest rest join(" ")
        if(name asNumber isNan,
          c := silica Command with(name uppercase, contents)
          silica TokenTable add(self currentNamespace, 
                                name lowercase, 
                                c
          )
          write("--> COMMAND " .. self currentNamespace constructName .. "::" .. name uppercase .. " defined.")
          ,
          write("--> COMMAND names cannot begin with numbers.")
        )
      )
      return nil
    )
    
    // function definition?
    if(out at(1) == ":=", 
      compound := out at(0) splitNoEmpties("(",",",")")
      name := compound at(0)
      if(self validName(name) not,
        write("--> FUNCTION name is invalid.")
        ,
        params := compound rest
        contents := out rest rest join(" ")
        if(name asNumber isNan,
          f := silica Function with(name uppercase, contents, params)
          silica TokenTable add(self currentNamespace,
                                name lowercase,
                                f
          )
          write("--> FUNCTION " .. self currentNamespace constructName .. "::" .. name uppercase .. " defined.")
          ,
          write("--> FUNCTION names cannot begin with numbers.")
        )
      )
      return nil
    )
    
    // mode definition?
    if(out at(1) == "!!",
      name := out at(0)
      intervals := out rest rest map(x, x asNumber)
      if(intervals sum != silica PitchNames size,
        write("--> Cannot define mode " .. name asMutable uppercase .. ": intervals must sum to " .. silica PitchNames size .. ".")
        return nil
      )
      if(silica mode(name uppercase) != nil,
        write("--> Cannot redefine mode " .. name asMutable uppercase .. ".")
        return nil
      )
      //writeln(intervals)
      silica ModeTable new(name uppercase, intervals);
      ns := silica namespace("home")
      m := silica mode(name uppercase)
      //writeln(m intervals)
      silica PitchNames foreach(tonic,
        ctx := Object clone
        ctx sname := tonic .. "-" .. m name
        silica ScaleTable new(ctx sname, m, tonic)
        ctx scale := silica scale(ctx sname)
        //writeln(ctx scale mode)
        silica TokenTable add(
          ns, 
          ctx sname asMutable lowercase, 
          silica ScaleChanger with(
            ctx sname asMutable uppercase,
            "(USER DEFINED) Attempts to relatively push the scale " .. ctx sname asMutable uppercase .. " onto the scalestack.",
            block(
              silica Note changeScaleRelative(scale)
            ) setScope(ctx)
        ))
        silica TokenTable add(
          ns, 
          (ctx sname .. "$") asMutable lowercase, 
          silica ScaleChanger with(
            (ctx sname .. "$") asMutable uppercase,
            "(USER DEFINED) Absolutely pushes the scale " .. (ctx sname .. "$") asMutable uppercase .. " onto the scalestack.", 
            block(
              silica Note changeScale(scale)
            ) setScope(ctx)
        ))
      )
      write("--> MODE " .. name uppercase .. " defined.")
      return nil
    )

    // auto invariance mode?
    if(Lobby ?REPL_AUTOINVARIANT,
      out prepend("pushstate")
      out append("popstate")
    )
    
    // repetition and grouping factors, and concurrent lines
    changed := true
    valid := true
    depth := 0
    while(changed and valid and (depth < REPL_MAX_RECURSIVE_DEPTH),
      depth = depth + 1
      changed = false
      in_2 := out join(" ")
      out := list
      toks := in_2 splitNoEmpties
      toks foreach(tok,
        
        // concurrent lines
        if(tok containsSeq("^"),
          changed = true
          out append("[")
          out append("pushstate")
          out append(tok beforeSeq("^"))
          out append("popstate")
          out append("||")
          out append(tok afterSeq("^"))
          out append("]")
          continue
        )
        
        // transform
        if(tok containsSeq(":") and tok beginsWithSeq(":") not and silica token(currentNamespace, tok lowercase) == nil,
          // not quite right yet... need to do rightmost decomposition
          changed = true
          pos := tok size - 1
          while(tok exSlice(pos, pos+1) != ":",
            pos = pos - 1
          )
          before := tok exSlice(0, pos)
          after := tok exSlice(pos)
          out append("**")
          out append(before)
          out append("*")
          out append(after)
          continue
        )
        
        // repetition/grouping factors
        if(tok asNumber isNan,
          // not a repetition factor
          if(tok containsSeq("+"),
            // grouping factor
            changed = true
            out append(tok beforeSeq("+"))
            out append(tok afterSeq("+"))
            ,
            // not a grouping factor or repetition factor
            ret := self interpretToken(tok asMutable lowercase, false, self currentNamespace)
            if(ret first == nil,
              writeln("--> ERROR: cannot recognize token \"" .. tok asMutable uppercase .. "\" within namespace \"" .. self currentNamespace constructName .. "\".")
              if(?REPL_DEBUG, writeln("TRACE (preprocess) breaking with: " .. out join(" ")))
              valid = false
              break
            )
            // macro/fn/cmd
            if(ret second,
              changed = true
              out append(ret first)
              ,
              // must be a primitive
              out append(tok)
            )
          )
          ,
          // repetition factor
          changed = true
          num := tok asNumber
          info := tok afterSeq(num asString)
          num repeat(
            out append(info)
          )
        )
      )
      if(valid not, out = list)
      if(depth >= REPL_MAX_RECURSIVE_DEPTH,
        writeln("--> ERROR: infinite loop detected.  Bailing out.")
        out = list
      )
      if(?REPL_DEBUG, writeln("TRACE (preprocess) step: " .. out join(" ")))
    )
    if(?REPL_DEBUG, writeln("TRACE (preprocess) returning: " .. out join(" ")))
    out join(" ")
  )
  
  interpretToken := method(token, final, namespace,
    // find function, if it is one
    tokenName := token beforeSeq("(")
    //writeln(tokenName)
    // get token
    itok := silica token(namespace, tokenName)
    //writeln(itok)
    
    // function?
    if(itok isKindOf(silica Function),
      params := token afterSeq("(")
      if(params != nil, params = params removeLast)
      return self interpretFunction(itok, params)
    )
    
    // macro/command?
    if(itok isKindOf(silica Macro), // macros and commands
      return self interpretMacro(itok)
    )
        
    // meta?
    if(itok isKindOf(silica MetaCommand),
      if(final,
        param := token afterSeq("(")
        if(param != nil, param = param beforeSeq(")"))
        return self interpretMetaCommand(itok, param)
        ,
        return list(token, false)
      )
    )
    
    // primitive?
    if(itok isKindOf(silica Primitive),
      if(final,
        return self interpretPrimitive(itok)
        ,
        return list(token, false)
      )
    )
    
    // transform?
    if(itok isKindOf(silica Transform),
      return list(token, false)
    )
    
    // other things?
    if(token == "{" or token == "}" or token == "[" or token == "]" or token == "||" or token == "*" or token == "**",
      return list(list(token, token), false)
    )
        
    // uninterpretable.. jump up a namespace
    if(namespace parent != nil,
      self interpretToken(token, final, namespace parent)
      ,
      return list(nil, false)
    )
  )
  
  interpretFunction := method(fn, params,
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): Function found: " .. fn))
    list(fn expand(params), true)
  )
  
  interpretMacro := method(macro, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): Macro found: " .. macro))
    list(macro expand, true)
  )
  
  interpretPrimitive := method(primitive, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): Primitive found: " .. primitive))
    out := primitive execute
    list(out, true)
  )
  
  interpretMetaCommand := method(meta, param, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): MetaCommand found: " .. meta))
    out := meta execute(param)
    list(list("META> " .. out, nil), true)
  )
  
  applyTransforms := method(in,
    if(in containsSeq(":") not, 
      if(?REPL_DEBUG, writeln("TRACE (applyTransforms): Nothing to do."))
      return in
    ) // nothing to do if no transforms present
    
    
    in_l := in splitNoEmpties
    t_count := 0
    out := list
    current := list
    in_l foreach(i, tok,
      if(tok == "**",
        t_count = t_count + 1
        continue
      )
      if(tok == "*",
        t_count = t_count - 1
        continue
      )
      if(current size == 0 and t_count == 0,
        out append(tok)
        ,
        if(silica token(self currentNamespace, tok lowercase) isKindOf(silica Transform),
          current = self applyTransform(silica token(self currentNamespace, tok lowercase), current)
          ,
          if(t_count > 0,
            current append(tok)
            ,
            current foreach(tok2,
              out append(tok2)
            )
            current = list
            out append(tok)
          )
        )
      )
    )
    
    if(current size != 0,
      current foreach(tok2,
        out append(tok2)
      )
    )
    if(?REPL_DEBUG, writeln("TRACE (applyTransforms): Returning: " .. out join(" ")))
    out join(" ")
  )
  
  applyTransform := method(trans, input,
    if(?REPL_DEBUG, writeln("TRACE (applyTransform): Applying transform " .. trans name .. " on input " .. input))
    trans execute(input join(" "), silica Note scale last) splitNoEmpties
  )
)
