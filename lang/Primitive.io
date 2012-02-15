// silica programming language
// Jacob M. Peck
// Primitive proto

if(?REPL_DEBUG, writeln("  + Loading Primitive.io"))

silica Primitive := Object clone do(
  name ::= nil
  behavior ::= nil
  
  init := method(
    self name = nil
    self behavior = nil
  )
  
  with := method(name, behavior,
    self clone setName(name) setBehavior(behavior)
  )
  
  execute := method(
    out := self behavior call
    out
  )
  
  asString := method(
    "< PRIMITIVE " .. self name .. " >"
  )
)
