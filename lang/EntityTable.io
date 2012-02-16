// silica programming language
// Jacob M. Peck
// EntityTable proto

if(?REPL_DEBUG, writeln("  + Loading EntityTable.io"))

silica EntityTable := Object clone do(
  table := Map clone
  
  init := method(
    self table = Map clone
  )
  
  get := method(name,
    self table at(name)
  )
  
  asString := method(
    "< ENTITYTABLE >"
  )
)