// Jacob M. Peck
// Transform proto

if(?REPL_DEBUG, writeln("  + Loading Transform.io"))

silica Transform := silica Entity clone do(
  behavior ::= nil
  
  init := method(
    self name = nil
    self behavior = nil
  )
  
  with := method(name, description, behavior,
    self clone setName(name) setDescription(description) setBehavior(behavior)
  )
  
  execute := method(instring, scale,
    self behavior call(instring, scale)
  )
)
