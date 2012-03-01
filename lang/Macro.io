// silica programming language
// Jacob M. Peck
// Macro proto

if(?REPL_DEBUG, writeln("  + Loading Macro.io"))

silica Macro := silica Entity clone do(
  value ::= nil
  
  init := method(
    self value = nil
    self name = nil
  )
  
  expand := method(
    self value
  )
  
  with := method(name, value,
    self clone setName(name) setValue(value)
  )
  
  asString := method(
    "< MACRO " .. self name uppercase .. " >"
  )
)
