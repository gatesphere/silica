// silica programming language
// Jacob M. Peck
// TonalWorld proto

if(?REPL_DEBUG, writeln("  + Loading TonalWorld.io"))

silica TonalWorld := Object clone do(
  currentNamespace ::= "home"
  
  clone := method(self)
  
  interpretToken := method(token,
    // find function, if it is one
    splits := token split("(", ")", ",")
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
    
    // primitive?
    if(itok isKindOf(silica Primitive),
      return self interpretPrimitive(itok)
    )
    
    // meta?
    if(itok isKindOf(silica MetaCommand),
      return self interpretMetaCommand(itok)
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
    fn expand(params)
  )
  
  interpretMacro := method(macro, macro expand)
  
  interpretPrimitive := method(primitive, 
    out := primitive execute
    out
  )
  
  interpretMetaCommand := method(m, m)
)
