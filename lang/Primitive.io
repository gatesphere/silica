// silica programming language
// Jacob M. Peck
// Primitive proto

if(?REPL_DEBUG, writeln("  + Loading Primitive.io"))

silica Primitive := silica Entity clone do(
  behavior ::= nil
  
  init := method(
    self name = nil
    self behavior = nil
  )
  
  with := method(name, description, behavior,
    self clone setName(name) setDescription(description) setBehavior(behavior)
  )
  
  execute := method(
    out := self behavior call
    out
  )
  
  asString := method(
    "< PRIMITIVE " .. self name .. " >"
  )
)
