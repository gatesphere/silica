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
      self interepretFunction(itok, splits rest); return
    )
    
    // macro/command?
    if(itok isKindOf(silica Macro), // macros and commands
      self interpretMacro(itok); return
    )
    
    // primitive?
    if(itok isKindOf(silica Primitive),
      self interepretPrimitive(itok); return
    )
    
    // meta?
    if(itok isKindOf(silica MetaCommand),
      self interpretMetaCommand(itok); return
    )
    
    // other things?
    if(token == "{" or token == "}",
      return token
    )
    if(token == ">>",
      self defineMacro(token); return
    )
    if(token == "=",
      self defineCommand(token); return
    )
    if(token == ":=",
      self defineFunction(token); return
    )
    
    // uninterpretable
    return nil
  )
  
  interpretFunction := method(fn, params,
    fn expand(params)
  )
  
  interpretMacro := method(macro, macro expand)
  
  interpretPrimative := method(x, x)
  
  interpretMetaCommand := method(m, m)
)
