// silica programming language
// Jacob M. Peck
// Instrument proto

if(?REPL_DEBUG, writeln("  + Loading Instrument.io"))

silica Instrument := silica Entity clone do(
  with := method(name,
    self clone setName(name)
  )
  
  asString := method(
    "< INSTRUMENT " .. self name .. " >"
  )
)

silica InstrumentTable := silica EntityTable clone do(
  clone := method(self)
  new := method(name,
    self table atIfAbsentPut(name, silica Instrument with(name))
  )
  
  asString := method(
    "< INSTRUMENTTABLE >"
  )
)
