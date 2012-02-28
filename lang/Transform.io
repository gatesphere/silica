// Jacob M. Peck
// Transform proto

if(?REPL_DEBUG, writeln("  + Loading Transform.io"))

silica Transform := Object clone do(
  name ::= nil
  behavior ::= nil
  
  init := method(
    self name = nil
    self behavior = nil
  )
  
  with := method(name, behavior,
    self clone setName(name) setBehavior(behavior)
  )
  
  execute := method(instring, scale,
    self behavior call(instring, scale)
  )
)
