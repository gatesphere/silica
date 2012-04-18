// silica programming language
// Jacob M. Peck
// Parser proto

if(?REPL_DEBUG, writeln("  + Loading Parser.io"))

/*
 * Class: Parser
 *
 * The silica parser
 */
silica REPL Parser := Object clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * operation_table - a list of operation phases with precedence
   * definition_table - a list of definition phases with precedence
   * parse_cache - a cache used to speed parsing
   */
  operation_table ::= list setSize(16)
  definition_table ::= list setSize(16)
  parse_cache ::= Map clone
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Initializers 
  /*
   * Method: clone
   *
   * Returns the Parser object (singleton)
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   The singleton Parser object
   */
  clone := method(self)
  
  /*
   * Method: initialize
   *
   * Adds the default definition and operation phases at the default precedences
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   self
   */
  initialize := method(
    self add_definition(self getSlot("defineMacro"), block(x, x at(1) == ">>"), 0)
    self add_definition(self getSlot("defineCommand"), block(x, x at(1) == "="), 0)
    self add_definition(self getSlot("defineFunction"), block(x, x at(1) == ":="), 0)
    self add_definition(self getSlot("defineMode"), block(x, x at(1) == "!!"), 0)
    self add_operation(self getSlot("simplifyVoices"), 0)
    self add_operation(self getSlot("simplifyTransforms"), 4)
    self add_operation(self getSlot("simplifyFactors"), 8)
    self add_operation(self getSlot("simplifyExpansions"), 12)
    
    self
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Pluggable API
  /*
   * Method: add_operation(operation, precedence)
   *
   * Adds an operation phase to the operation_table with the given precedence
   *
   * Parameters:
   *   operation - the operation phase, as an Io block
   *   precedence - the precedence, as a number in the range [0..15]
   *
   * Returns:
   *   operation_table
   * 
   * See Also:
   *   <add_definition(definition, test, precedence)>
   */
  add_operation := method(operation, precedence,
    // constrain precedence
    if(precedence < 0, precedence = 0)
    if(precedence > 15, precedence = 15)
    opList := self operation_table at(precedence)
    if(opList == nil, opList = list)
    opList append(operation)
    self operation_table atPut(precedence, opList)
  )
  
  /*
   * Method: add_definition(definition, test, precedence)
   *
   * Adds a definition phase to the definition_table with the given precedence and predicate test
   *
   * Parameters:
   *   definition - the definition phase, as an Io block
   *   test - the predicate test, as an Io block
   *   precedence - the precedence, as a number in the range [0..15]
   *
   * Returns:
   *   definition_table
   * 
   * See Also:
   *   <add_operation(operation, precedence)>
   */
  add_definition := method(definition, test, precedence,
    // constrain precedence
    if(precedence < 0, precedence = 0)
    if(precedence > 15, precedence = 15)
    defList := self definition_table at(precedence)
    if(defList == nil, defList = list)
    defList append(list(test, definition))
    self definition_table atPut(precedence, defList)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Validators
  /*
   * Method: validName(name)
   *
   * Checks to see whether the given name is valid for a token
   *
   * Parameters:
   *   name - the name to check
   *
   * Returns:
   *   boolean
   */
  validName := method(name,
    out := true
    if(name findSeqs(list("(", ")", ":", "=", "+", "-", ",", ">>")) != nil, out = false)
    symbol := silica token(silica namespace("home"), name lowercase)
    if(symbol isKindOf(silica Primitive) or symbol isKindOf(silica MetaCommand) or symbol isKindOf(silica Transform),
      out := false
    )
    out
  )
  
  /*
   * Method: checkValidity(changed, valid, out, repl)
   *
   * Checks to see whether all tokens in out are valid
   *
   * Parameters:
   *   changed - has the out string changed?
   *   valid - is the out string valid?
   *   out - the input string
   *   repl - the <REPL> object
   *
   * Returns:
   *   list(changed, valid, out)
   */ 
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
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Simplification
  /*
   * Method: preprocess(in, repl)
   *
   * Checks for definitions, and, failing that, calls simplify.
   *
   * Parameters:
   *   in - the input string
   *   repl - the <REPL> object
   *
   * Returns:
   *   string
   * 
   * See Also:
   *   <simplify(out, repl)>
   */
  preprocess := method(in, repl,
    repl mcmode = false
    done := false
    
    out := in splitNoEmpties
    
    for(i, 0, 16,
      defList := definition_table at(i)
      if(defList == nil, continue)
      defList foreach(def,
        test := def at(0)
        defn := def at(1)
        if(test call(out), 
          done = defn call(out, repl)
          if(done, break)
        )
      )
      if(done, break)
    )
    
    if(done, return nil)

    // metacommand mode?
    if(out at(0) beginsWithSeq("-"), repl mcmode = true)

    // mcmode (return just the first metacommand)
    if(repl mcmode, return out at(0))

    // auto invariance mode?
    if(Lobby ?REPL_AUTOINVARIANT and repl mcmode not,
      out prepend("pushstate")
      out append("popstate")
    )

    out = self simplify(out, repl)

    if(?REPL_DEBUG, writeln("TRACE (preprocess) returning: " .. out join(" ")))
    out join(" ")
  )
  
  /*
   * Method: simplify(out, repl)
   *
   * Attempts to reduce out to a string of primitives
   *
   * Parameters:
   *   out - the input string
   *   repl - the <REPL> object
   *
   * Returns:
   *   string
   * 
   * See Also:
   *   <preprocess(in, repl)>
   */
  simplify := method(out, repl,
    // caching
    //self cache_reset
    
    // concurrent lines
    changed := true
    valid := true
    depth := 0
    values := list // multiple return values, stored as list(changed, valid, out)
    while(changed and valid and (depth < REPL_MAX_RECURSIVE_DEPTH) and repl mcmode not,
      depth = depth + 1
      changed = false
      
      for(i, 0, 16,
        opList := self operation_table at(i)
        if(opList == nil, continue)
        opList foreach(op,
          if(?REPL_DEBUG, writeln("TRACE (simplify) running operations for precedence " .. i))
          values = op call(changed, valid, out, repl)
          changed = values at(0)
          valid = values at(1)
          out = values at(2)
          if(valid not, break)
        )
      )      
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

  //////////////////////////////////////////////////////////////////////////////
  // Group: Default Operation Phases
  /*
   * Method: simplifyVoices
   *
   * Simplifies any concurrent voices in the string
   */
  simplifyVoices := block(changed, valid, out, repl,
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
  
  /*
   * Method: simplifyTransforms
   *
   * Simplifies any transforms in the string
   */
  simplifyTransforms := block(changed, valid, out, repl,
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
  
  /*
   * Method: simplifyFactors
   *
   * Simplifies any repetition or grouping factors in the string
   */
  simplifyFactors := block(changed, valid, out, repl,
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
  
  /*
   * Method: simplifyExpansions
   *
   * Simplifies any Macros/Commands/Functions in the string
   */
  simplifyExpansions := block(changed, valid, out, repl,
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
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Default Definition Phases
  /*
   * Method: defineMacro
   *
   * Defines a new Macro
   */
  defineMacro := block(out, repl,
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
    return true
  )
  
  /*
   * Method: defineCommand
   *
   * Defines a new Command
   */
  defineCommand := block(out, repl,
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
    return true
  )
  
  /*
   * Method: defineFunction
   *
   * Defines a new Function
   */
  defineFunction := block(out, repl,
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
    return true
  )
  
  /*
   * Method: defineMode
   *
   * Defines a new Mode
   */
  defineMode := block(out, repl,
    name := out at(0)
    intervals := out rest rest map(x, x asNumber)
    if(intervals sum != silica PitchNames size,
      if(repl silent not,
        write("--> Cannot define mode " .. name asMutable uppercase .. ": intervals must sum to " .. silica PitchNames size .. ".")
      )
      return true
    )
    if(silica mode(name uppercase) != nil,
      if(repl silent not,
        write("--> Cannot redefine mode " .. name asMutable uppercase .. ".")
      )
      return true
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
    return true
  )
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Interpretation
  /*
   * Method: interpretToken(token, final, namespace, repl)
   *
   * Attempts to interpret a token, in one of two modes:
   *   final == true - expand any Macros/Commands/Functions/MetaCommands/Primitives
   *   final == false - do not expand
   *
   * Parameters:
   *   token - the token name
   *   final - the mode
   *   namespace - the namespace to look in
   *   repl - the <REPL> object
   *
   * Returns:
   *   list(textual_output, siren_output)
   */
  interpretToken := method(token, final, namespace, repl,
    if(?REPL_DEBUG, writeln("TRACE (interpretToken) interpreting: " .. token))
    // find function, if it is one
    tokenName := token beforeSeq("(")
    //writeln(tokenName)
    // get token
    
    /*
    itok := self cache_lookup(namespace, tokenName)
    if(itok == nil,
      itok = silica token(namespace, tokenName)
      if(itok != nil, self cache_add(namespace, tokenName, itok))
    )
    */
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
  
  /*
   * Method: interpretFunction(fn, params, repl)
   *
   * Expands a function.
   *
   * Parameters:
   *   fn - the function
   *   params - the parameter list
   *   repl - the <REPL> object
   *
   * Returns:
   *   list(textual_output, siren_output)
   */
  interpretFunction := method(fn, params, repl,
    if(?REPL_DEBUG, writeln("TRACE (interpretFunction): Function found: " .. fn))
    list(fn expand(params), true)
  )
  
  /*
   * Method: interpretMacro(macro, repl)
   *
   * Expands a Macro.
   *
   * Parameters:
   *   macro - the macro
   *   repl - the <REPL> object
   *
   * Returns:
   *   list(textual_output, siren_output)
   */
  interpretMacro := method(macro, repl, 
    if(?REPL_DEBUG, writeln("TRACE (interpretMacro): Macro found: " .. macro))
    list(macro expand, true)
  )
  
  /*
   * Method: interpretPrimitive(primitive, repl)
   *
   * Executes a Primitive.
   *
   * Parameters:
   *   primitive - the primitive
   *   repl - the <REPL> object
   *
   * Returns:
   *   list(textual_output, siren_output)
   */
  interpretPrimitive := method(primitive, repl, 
    if(?REPL_DEBUG, writeln("TRACE (interpretPrimitive): Primitive found: " .. primitive))
    out := primitive execute
    list(out, true)
  )
  
  /*
   * Method: interpretMetaCommand(meta, param, repl)
   *
   * Executes a MetaCommand with the given parameters.
   *
   * Parameters:
   *   meta - the metacommand
   *   param - the parameters
   *   repl - the <REPL> object
   *
   * Returns:
   *   list(textual_output, siren_output)
   */
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
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Transformations
  /*
   * Method: applyTransforms(in)
   *
   * Applies all transformations present in the in string to the in string.
   *
   * Parameters:
   *   in - the input string
   *
   * Returns:
   *   string
   */
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
  
  /*
   * Method: applyTransform(trans, input)
   *
   * Applies the transformation to the input string
   *
   * Parameters:
   *   trans - the transformation
   *   in - the input string
   *
   * Returns:
   *   list
   */
  applyTransform := method(trans, input,
    if(?REPL_DEBUG, writeln("TRACE (applyTransform): Applying transform " .. trans name .. " on input " .. input))
    trans execute(input join(" "), silica Note scale last) splitNoEmpties
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Caching
  /*
   * Method: cache_lookup(namespace, token)
   *
   * Looks the token up within the parse_cache
   *
   * Parameters:
   *   namespace - the namespace
   *   token - the token
   *
   * Returns:
   *   the token, or nil if not in parse_cache
   *
   * See also:
   *   <cache_add(namespace, token, value)>, <cache_reset>
   */
  cache_lookup := method(namespace, token,
    namespace_table := self parse_cache at(namespace constructName)
    if(namespace_table == nil, return nil)
    namespace_table at(token)
  )
  
  /*
   * Method: cache_add(namespace, token, value)
   *
   * Adds a token to the parse_cache
   *
   * Parameters:
   *   namespace - the namespace
   *   token - the token
   *   value - the value of the token
   *
   * Returns:
   *   self
   *
   * See also:
   *   <cache_lookup(namespace, token)>, <cache_reset>
   */
  cache_add := method(namespace, token, value,
    //writeln("ns: " .. namespace .. " tok: " .. token .. " val: " .. value)
    namespace_table := self parse_cache atIfAbsentPut(namespace constructName, Map clone)
    namespace_table atIfAbsentPut(token, value)
    self
  )
  
  /*
   * Method: cache_reset
   *
   * Resets the cache (emptying it)
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   self
   *
   * See also:
   *   <cache_lookup(namespace, token)>, <cache_add(namespace, token, value)>
   */
  cache_reset := method(
    self parse_cache = Map clone
    self
  )
)
