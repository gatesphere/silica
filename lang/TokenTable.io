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
)
