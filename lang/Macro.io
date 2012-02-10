// silica programming language
// Jacob M. Peck
// Macro proto

if(?REPL_DEBUG, writeln("  + Loading Macro.io"))

silica Macro := Object clone do(
  value ::= nil
  name ::= nil
  
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
)
