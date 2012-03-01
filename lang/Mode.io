// silica programming language
// Jacob M. Peck
// Mode proto

if(?REPL_DEBUG, writeln("  + Loading Mode.io"))

silica Mode := silica Entity clone do(
  intervals ::= nil
  
  init := method(
    self intervals = nil
    self name = nil
  )
  
  size := method( self intervals size )
  
  with := method(name, intervals,
    self clone setName(name) setIntervals(intervals)
  )
  
  asString := method(
    "< MODE " .. self name asMutable uppercase .. " >"
  )
)


silica ModeTable := silica EntityTable clone do(
  clone := method(self)
  new := method(name, intervals,
    self table atIfAbsentPut(name, silica Mode with(name, intervals))
  )
  
  asString := method(
    "< MODETABLE >"
  )
)