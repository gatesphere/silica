// silica programming language
// Jacob M. Peck
// MetaCommand proto

if(?REPL_DEBUG, writeln("  + Loading MetaCommand.io"))

silica MetaCommand := silica Primitive clone do(
  asString := method(
    "< METACOMMAND " .. self name .. " >"
  )
)
