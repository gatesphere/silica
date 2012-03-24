// silica programming language
// Jacob M. Peck
// Parser proto

if(?REPL_DEBUG, writeln("  + Loading Parser.io"))

silica REPL Parser := Object clone do(
  
  validName := method(name,
    out := true
    if(name findSeqs(list("(", ")", ":", "=", "+", "-", ",", ">>")) != nil, out = false)
    symbol := silica token(silica namespace("home"), name lowercase)
    if(symbol isKindOf(silica Primitive) or symbol isKindOf(silica MetaCommand) or symbol isKindOf(silica Transform),
      out := false
    )
    out
  )
  
  // get the input to be all primitives
  preprocess := method(in, repl,
    repl mcmode = false
    
    out := in splitNoEmpties
    
    // macro definition?
    if(out at(1) == ">>", return self defineMacro(out, repl))
    
    // command definition?
    if(out at(1) == "=", return self defineCommand(out, repl))
    
    // function definition?
    if(out at(1) == ":=", return self defineFunction(out, repl))
    
    // mode definition?
    if(out at(1) == "!!", return self defineMode(out, repl))

    // metacommand mode?
    if(out at(0) beginsWithSeq("-"), repl mcmode = true)

    // mcmode (return just the first metacommand)
    if(repl mcmode, return out at(0))

    // auto invariance mode?
    if(Lobby ?REPL_AUTOINVARIANT and repl mcmode not,
      out prepend("pushstate")
      out append("popstate")
    )
    
    // repetition and grouping factors, concurrent lines, and transforms
    out = self simplify(out, repl)
    
    if(?REPL_DEBUG, writeln("TRACE (preprocess) returning: " .. out join(" ")))
    out join(" ")
  )
  
  defineMacro := method(out, repl,
    name := out at(0)
    if(self validName(name) not,
      if(repl silent not,
        write("--> MACRO name is invalid.")
      )
      ,
      contents := out rest rest join(" ")
      if(name asNumber isNan,
        m := silica Macro with(name uppercase, contents)
        silica TokenTable add(repl currentNamespace, 
                              name lowercase, 
                              m
        )
        if(repl silent not, 
          write("--> MACRO " .. repl currentNamespace constructName .. "::" .. name uppercase .. " defined.")
        )
        ,
        if(repl silent not,
          write("--> MACRO names cannot begin with numbers.")
        )
      )
    )
    return nil
  )
  
  defineCommand := method(out, repl,
    name := out at(0)
    if(self validName(name) not,
      if(repl silent not,
        write("--> COMMAND name is invalid.")
      )
      ,
      contents := out rest rest join(" ")
      if(name asNumber isNan,
        c := silica Command with(name uppercase, contents)
        silica TokenTable add(repl currentNamespace, 
                              name lowercase, 
                              c
        )
        if(repl silent not,
          write("--> COMMAND " .. repl currentNamespace constructName .. "::" .. name uppercase .. " defined.")
        )
        ,
        if(repl silent not,
          write("--> COMMAND names cannot begin with numbers.")
        )
      )
    )
    return nil
  )
  
  defineFunction := method(out, repl,
    compound := out at(0) splitNoEmpties("(",",",")")
    name := compound at(0)
    if(self validName(name) not,
      if(repl silent not,
        write("--> FUNCTION name is invalid.")
      )
      ,
      params := compound rest
      contents := out rest rest join(" ")
      if(name asNumber isNan,
        f := silica Function with(name uppercase, contents, params)
        silica TokenTable add(repl currentNamespace,
                              name lowercase,
                              f
        )
        if(repl silent not,
          write("--> FUNCTION " .. repl currentNamespace constructName .. "::" .. name uppercase .. " defined.")
        )
        ,
        if(repl silent not,
          write("--> FUNCTION names cannot begin with numbers.")
        )
      )
    )
    return nil
  )
  
  defineMode := method(out, repl,
    name := out at(0)
    intervals := out rest rest map(x, x asNumber)
    if(intervals sum != silica PitchNames size,
      if(repl silent not,
        write("--> Cannot define mode " .. name asMutable uppercase .. ": intervals must sum to " .. silica PitchNames size .. ".")
      )
      return nil
    )
    if(silica mode(name uppercase) != nil,
      if(repl silent not,
        write("--> Cannot redefine mode " .. name asMutable uppercase .. ".")
      )
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
    ctx := Object clone
    ctx x := m name
    silica TokenTable add(
      ns,
      m name asMutable lowercase,
      silica ScaleChanger with(m name asMutable uppercase,
          "(USER DEFINED) Relatively pushes the " .. m name .. " scale matching the note's current pitch class onto the scalestack.",
          block(
            tonic := silica Note scale last getNameForDegree(silica Note degree)
            scalename := tonic .. "-" .. x asMutable uppercase
            silica Note changeScaleRelative(silica scale(scalename))
          ) setScope(ctx)
    ))
    if(repl silent not,
      write("--> MODE " .. name uppercase .. " defined.")
    )
    return nil
  )
  
  simplify := method(out, repl,
    // concurrent lines
    changed := true
    valid := true
    depth := 0
    values := list // multiple return values, stored as list(changed, valid, out)
    while(changed and valid and (depth < REPL_MAX_RECURSIVE_DEPTH) and repl mcmode not,
      depth = depth + 1
      changed = false

      // concurrent voices
      values = simplifyVoices(changed, valid, out, repl)
      changed = values at(0)
      valid = values at(1)
      out = values at(2)
      
      if(valid not, break)
      
      // transforms
      values = simplifyTransforms(changed, valid, out, repl)
      changed = values at(0)
      valid = values at(1)
      out = values at(2)
      
      if(valid not, break)
      
      // repetition/grouping factors
      values = simplifyFactors(changed, valid, out, repl)
      changed = values at(0)
      valid = values at(1)
      out = values at(2)
      
      if(valid not, break)
      
      // macros, commands, and functions
      values = simplifyExpansions(changed, valid, out, repl)
      changed = values at(0)
      valid = values at(1)
      out = values at(2)
      
      if(valid not, break)
      
      if(?REPL_DEBUG, writeln("TRACE (simplify) step " .. depth .. ": " .. out join(" ")))
    )
    
    // check validity
    values = checkValidity(changed, valid, out, repl)
    changed = values at(0)
    valid = values at(1)
    out = values at(2)
    
    if(valid not, out = list)
    if(depth >= REPL_MAX_RECURSIVE_DEPTH,
      if(repl silent not,
        writeln("--> ERROR: infinite loop detected.  Bailing out.")
      )
      out = list
    )
    out
  )
  
  simplifyVoices := method(changed, valid, out, repl,
    if(?REPL_DEBUG, writeln("TRACE (simplifyVoices) entering with: " .. out join(" ")))
    in_2 := out join(" ")
    out := list
    toks := in_2 splitNoEmpties
    inBrackets := false
    toks foreach(tok,
      if(tok == "[", inBrackets = true)
      if(tok == "]", inBrackets = false)
      
      // concurrent lines
      if(tok containsSeq("^"),
        changed = true
        if(inBrackets not,
          out append("[")
        )
        while(tok containsSeq("^"),
          out append("pushstate")
          out append(tok beforeSeq("^"))
          out append("popstate")
          out append("||")
          tok = tok afterSeq("^")
        )
        out append(tok)
        if(inBrackets not,
          out append("]")
        )
        continue
        ,
        out append(tok)
      )
    )
    if(?REPL_DEBUG, writeln("TRACE (simplifyVoices) returning: " .. out join(" ")))
    list(changed, valid, out)
  )
      
  simplifyTransforms := method(changed, valid, out, repl,
    if(?REPL_DEBUG, writeln("TRACE (simplifyTransforms) entering with: " .. out join(" ")))
    in_2 := out join(" ")
    out := list
    toks := in_2 splitNoEmpties
    toks foreach(tok,
      // transform
      if(tok containsSeq(":") and tok beginsWithSeq(":") not and silica token(repl currentNamespace, tok lowercase) == nil,
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
        ,
        out append(tok)
      )
    )
    if(?REPL_DEBUG, writeln("TRACE (simplifyTransforms) returning: " .. out join(" ")))
    list(changed, valid, out)
  )
  
  simplifyFactors := method(changed, valid, out, repl,
    if(?REPL_DEBUG, writeln("TRACE (simplifyFactors) entering with: " .. out join(" ")))
    // repetition/grouping factors
    in_2 := out join(" ")
    out := list
    toks := in_2 splitNoEmpties
    toks foreach(tok,    
      if(tok asNumber isNan not,
        // a repetition factor
        changed = true
        num := tok asNumber
        info := tok afterSeq(num asString)
        num repeat(out append(info))
        ,
        if(tok containsSeq("+"),
          // grouping factor
          changed = true
          out append(tok beforeSeq("+"))
          out append(tok afterSeq("+"))
          ,
          // not a grouping factor or repetition factor
          out append(tok)
        )
      )
    )
    if(?REPL_DEBUG, writeln("TRACE (simplifyFactors) returning: " .. out join(" ")))
    list(changed, valid, out)
  )
  
  simplifyExpansions := method(changed, valid, out, repl,
    if(?REPL_DEBUG, writeln("TRACE (simplifyExpansions) entering with: " .. out join(" ")))
    in_2 := out join(" ")
    out := list
    toks := in_2 splitNoEmpties
    toks foreach(tok,
      ret := self interpretToken(tok asMutable lowercase, false, repl currentNamespace, repl)
      // macro/fn/cmd
      if(ret second,
        changed = true
        out append(ret first)
        ,
        // must be a primitive
        out append(tok)
      )
    )
    if(?REPL_DEBUG, writeln("TRACE (simplifyExpansions) returning: " .. out join(" ")))
    list(changed, valid, out)
  )
  
  checkValidity := method(changed, valid, out, repl,
    if(?REPL_DEBUG, writeln("TRACE (checkValidity) entering with: " .. out join(" ")))
    in_2 := out join(" ")
    out := list
    toks := in_2 splitNoEmpties
    toks foreach(tok,
      ret := self interpretToken(tok asMutable lowercase, false, repl currentNamespace, repl)
      if(ret first == nil, // unknown token
        if(repl silent not,
          writeln("--> ERROR: cannot recognize token \"" .. tok asMutable uppercase .. "\" within namespace \"" .. repl currentNamespace constructName .. "\".")
        )
        if(?REPL_DEBUG, writeln("TRACE (checkValidity) breaking with: " .. out join(" ")))
        valid = false
        break
        ,
        out append(tok)
      )
    )
    list(changed, valid, out)
  )
  
  interpretToken := method(token, final, namespace, repl,
    if(?REPL_DEBUG, writeln("TRACE (interpretToken) interpreting: " .. token))
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
      return self interpretFunction(itok, params, repl)
    )
    
    // macro/command?
    if(itok isKindOf(silica Macro), // macros and commands
      return self interpretMacro(itok, repl)
    )
        
    // meta?
    if(itok isKindOf(silica MetaCommand),
      if(final,
        param := token afterSeq("(")
        if(param != nil, param = param beforeSeq(")"))
        return self interpretMetaCommand(itok, param, repl)
        ,
        return list(token, false)
      )
    )
    
    // primitive?
    if(itok isKindOf(silica Primitive),
      if(final,
        return self interpretPrimitive(itok, repl)
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
      self interpretToken(token, final, namespace parent, repl)
      ,
      return list(nil, false)
    )
  )
  
  interpretFunction := method(fn, params, repl,
    if(?REPL_DEBUG, writeln("TRACE (interpretFunction): Function found: " .. fn))
    list(fn expand(params), true)
  )
  
  interpretMacro := method(macro, repl, 
    if(?REPL_DEBUG, writeln("TRACE (interpretMacro): Macro found: " .. macro))
    list(macro expand, true)
  )
  
  interpretPrimitive := method(primitive, repl, 
    if(?REPL_DEBUG, writeln("TRACE (interpretPrimitive): Primitive found: " .. primitive))
    out := primitive execute
    list(out, true)
  )
  
  interpretMetaCommand := method(meta, param, repl, 
    if(?REPL_DEBUG, writeln("TRACE (interpretMetaCommand): MetaCommand found: " .. meta))
    if(repl mcmode not, 
      if(repl silent not,
        writeln("Ignoring Meta Command \"" .. meta name .. "\": not applicable in this context.")
      )
      list(list(nil, nil), true)
      ,
      out := meta execute(param)
      list(list("META> " .. out, nil), true)
    )
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
        if(silica token(silica namespace("home"), tok lowercase) isKindOf(silica Transform),
          current = self applyTransform(silica token(silica namespace("home"), tok lowercase), current)
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