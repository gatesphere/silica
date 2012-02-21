// silica programming language
// Jacob M. Peck
// REPL proto

if(?REPL_DEBUG, writeln("  + Loading REPL.io"))

silica REPL REPL := Object clone do(
  rl := ReadLine
  
  currentNamespace := silica namespace("home")
  
  clone := method(self)
  
  initialize := method(
    self rl prompt = "silica> "
    self
  )
  
  // loads the history
  loadHistory := method(
    try (
      self rl loadHistory(".silica_history")
    )
  )
  
  // saves the history
  saveHistory := method(
    try (
      self rl saveHistory(".silica_history")
    )
  )
  
  // runs the whole thing
  run := method(script,
    if(script != nil,
      // scripting mode
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
  
  // parsing tokens, one by one
  parse := method(in,
    processed := self preprocess(in)
    out := list("-->")
    if(processed == nil,
      writeln
      return
    )
    if(?REPL_DEBUG, writeln("TRACE (parse) received: " .. processed))
    processed splitNoEmpties foreach(tok,
      ret := self interpretToken(tok asMutable lowercase, true, self currentNamespace)
      if(ret != nil, out append(ret))
    )
    if(out size == 1, out append("okay")) 
    writeln(out join(" "))
  )
  
  // get the input to be all primitives
  preprocess := method(in,
    out := in splitNoEmpties
    
    // macro definition?
    if(out at(1) == ">>",
      name := out at(0)
      contents := out rest rest join(" ")
      m := silica Macro with(name uppercase, contents)
      silica TokenTable add(self currentNamespace, 
                            name lowercase, 
                            m
      )
      write("--> MACRO " .. self currentNamespace constructName .. "::" .. name uppercase .. " defined.")
      return nil
    )
    
    // command definition?
    if(out at(1) == "=", 
      name := out at(0)
      contents := out rest rest join(" ")
      c := silica Command with(name uppercase, contents)
      silica TokenTable add(self currentNamespace, 
                            name lowercase, 
                            c
      )
      write("--> COMMAND " .. self currentNamespace constructName .. "::" .. name uppercase .. " defined.")
      return nil
    )
    
    // function definition?
    if(out at(1) == ":=", 
      compound := out at(0) splitNoEmpties("(",",",")")
      name := compound at(0)
      params := compound rest
      contents := out rest rest join(" ")
      f := silica Function with(name uppercase, contents, params)
      silica TokenTable add(self currentNamespace,
                            name lowercase,
                            f
      )
      write("--> FUNCTION " .. self currentNamespace constructName .. "::" .. name uppercase .. " defined.")
      return nil
    )
    
    // repetition and grouping factors
    changed := true
    while(changed,
      changed = false
      in_2 := out join(" ")
      out := list
      toks := in_2 splitNoEmpties
      toks foreach(tok,
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
            if(ret == nil,
              writeln("--> ERROR: cannot recognize token \"" .. tok asMutable uppercase .. "\" within namespace \"" .. self currentNamespace constructName .. "\".")
              break
            )
            // macro/fn/cmd
            if(ret asMutable lowercase != tok asMutable lowercase,
              changed = true
              out append(ret)
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
      if(?REPL_DEBUG, writeln("TRACE (preprocess) step: " .. out join(" ")))
    )
    if(?REPL_DEBUG, writeln("TRACE (preprocess) returning: " .. out join(" ")))
    out join(" ")
  )
  
  interpretToken := method(token, final, namespace,
    // find function, if it is one
    tokenName := token beforeSeq("(")
    
    // get token
    itok := silica token(namespace, tokenName)
    
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
        return token
      )
    )
    
    // primitive?
    if(itok isKindOf(silica Primitive),
      if(final,
        return self interpretPrimitive(itok)
        ,
        return token
      )
    )
    
    // other things?
    if(token == "{" or token == "}",
      return token
    )
        
    // uninterpretable.. jump up a namespace
    if(namespace parent != nil,
      self interpretToken(token, final, namespace parent)
      ,
      return nil
    )
  )
  
  interpretFunction := method(fn, params,
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): Function found: " .. fn))
    fn expand(params)
  )
  
  interpretMacro := method(macro, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): Macro found: " .. macro))
    macro expand
  )
  
  interpretPrimitive := method(primitive, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): Primitive found: " .. primitive))
    out := primitive execute
    out
  )
  
  interpretMetaCommand := method(meta, param, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): MetaCommand found: " .. meta))
    out := meta execute(param)
    "META> " .. out
  )
)
