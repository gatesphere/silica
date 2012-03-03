// silica programming language
// Jacob M. Peck
// InstrumentChanger proto

if(?REPL_DEBUG, writeln("  + Loading InstrumentChanger.io"))

silica InstrumentChanger := silica Primitive clone do(
    asString := method(
    "< INSTRUMENTCHANGER " .. self name .. " >"
  )
)