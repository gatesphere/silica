// silica programming language
// Jacob M. Peck
// TokenTable proto

if(?REPL_DEBUG, writeln("  + Loading TokenTable.io"))

silica TokenTable := Object clone do(
  namespace_table := Map clone
  
  clone := method(self)

  get := method(namespace, name,
    token_table := self namespace_table at(namespace)
    if(token_table != nil,
      return token_table at(name),
      return nil
    )
  )
    
  add := method(namespace, name, token,
    token_table := self namespace_table atIfAbsentPut(namespace, Map clone)
    token_table atIfAbsentPut(name, token)
    self
  )
  
  initialize := method(
    self add("home", "play", silica Primitive with("PLAY", block(silica Note play)))
    self add("home", "rest", silica Primitive with("REST", block(silica Note rest)))
    self add("home", "mute", silica Primitive with("MUTE", block(silica Note mute)))
    self add("home", "rp", silica Primitive with("RP", block(silica Note rp)))
    self add("home", "lp", silica Primitive with("LP", block(silica Note lp)))
    self add("home", "cp", silica Primitive with("CP", block(silica Note cp)))
    self add("home", "x2", silica Primitive with("X2", block(silica Note x2)))
    self add("home", "x3", silica Primitive with("X3", block(silica Note x3)))
    self add("home", "x5", silica Primitive with("X5", block(silica Note x5)))
    self add("home", "x7", silica Primitive with("X7", block(silica Note x7)))
    self add("home", "s2", silica Primitive with("S2", block(silica Note s2)))
    self add("home", "s3", silica Primitive with("S3", block(silica Note s3)))
    self add("home", "s5", silica Primitive with("S5", block(silica Note s5)))
    self add("home", "s7", silica Primitive with("S7", block(silica Note s7)))
    
    self add("home", "exit", silica MetaCommand with("EXIT", block(silica exit = true; nil)))
  )
)
