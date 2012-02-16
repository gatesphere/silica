// silica programming language
// Jacob M. Peck
// REPL proto

if(?REPL_DEBUG, writeln("  + Loading REPL.io"))

silica REPL REPL := Object clone do(
  rl := ReadLine
  
  currentNamespace := "home"
  
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
  run := method(
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
      ret := self interpretToken(tok asMutable lowercase, true)
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
      write("--> MACRO " .. self currentNamespace .. "::" .. name uppercase .. " defined.")
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
      write("--> COMMAND " .. self currentNamespace .. "::" .. name uppercase .. " defined.")
      return nil
    )
    
    // function definition?
    // stub
    if(out at(1) == ":=", 
      compound := out at(0) splitNoEmpties("(",",",")")
      writeln(compound)
      name := compound at(0)
      params := compound rest
      writeln(params)
      contents := out rest rest join(" ")
      f := silica Function with(name uppercase, contents, params)
      silica TokenTable add(self currentNamespace,
                            name lowercase,
                            f
      )
      writeln("--> FUNCTION " .. self currentNamespace .. "::" .. name uppercase .. " defined.")
      writeln(f params)
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
            ret := self interpretToken(tok asMutable lowercase, false)
            if(ret == nil,
              writeln("--> ERROR: cannot recognize token \"" .. tok asMutable uppercase .. "\" within namespace \"" .. self currentNamespace .. "\".")
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
  
  interpretToken := method(token, final,
    // find function, if it is one
    splits := token splitNoEmpties("(", ")", ",")
    tokenName := splits at(0)
    
    // get token
    itok := silica token(self currentNamespace, tokenName)
    
    // function?
    if(itok isKindOf(silica Function),
      return self interpretFunction(itok, splits rest)
    )
    
    // macro/command?
    if(itok isKindOf(silica Macro), // macros and commands
      return self interpretMacro(itok)
    )
    
        
    // meta?
    if(itok isKindOf(silica MetaCommand),
      if(final,
        return self interpretMetaCommand(itok)
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
    if(token == ">>",
      return self defineMacro(token)
    )
    if(token == "=",
      return self defineCommand(token)
    )
    if(token == ":=",
      return self defineFunction(token)
    )
    
    // uninterpretable
    return nil
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
  
  interpretMetaCommand := method(meta, 
    if(?REPL_DEBUG, writeln("TRACE (interpretToken): MetaCommand found: " .. meta))
    out := meta execute
    "META> " .. out
  )
)
