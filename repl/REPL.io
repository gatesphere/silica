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
      if(ret first != nil, out append(ret first))
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
      return nil
    )
    
    // command definition?
    if(out at(1) == "=", 
      name := out at(0)
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
      return nil
    )
    
    // function definition?
    if(out at(1) == ":=", 
      compound := out at(0) splitNoEmpties("(",",",")")
      name := compound at(0)
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
      return nil
    )
    
    // mode definition?
    if(out at(1) == "!!",
      name := out at(0)
      intervals := out rest rest map(x, x asNumber)
      if(intervals sum != 12,
        write("--> Cannot define mode " .. name asMutable uppercase .. ": intervals must sum to 12.")
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
          silica Primitive with(
            ctx sname asMutable uppercase,
            block(
              silica Note changeScaleRelative(scale)
            ) setScope(ctx)
        ))
        silica TokenTable add(
          ns, 
          (ctx sname .. "$") asMutable lowercase, 
          silica Primitive with(
            (ctx sname .. "$") asMutable uppercase,
            block(
              silica Note changeScale(scale)
            ) setScope(ctx)
        ))
      )
      write("--> MODE " .. name uppercase .. " defined.")
      return nil
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
          out append("]")
          out append("[")
          out append(tok afterSeq("^"))
          out append("]")
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
    
    // other things?
    if(token == "{" or token == "}" or token == "[" or token == "]",
      return list(token, false)
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
    list("META> " .. out, true)
  )
)
