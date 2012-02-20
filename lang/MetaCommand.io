// silica programming language
// Jacob M. Peck
// MetaCommand proto

if(?REPL_DEBUG, writeln("  + Loading MetaCommand.io"))

silica MetaCommand := silica Primitive clone do(
  execute := method(params,
    out := self behavior call(params)
    out
  )
  
  asString := method(
    "< METACOMMAND " .. self name .. " >"
  )
)
