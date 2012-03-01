// silica programming language
// Jacob M. Peck
// ScaleChanger proto

if(?REPL_DEBUG, writeln("  + Loading ScaleChanger.io"))

silica ScaleChanger := silica Primitive clone do(
    asString := method(
    "< SCALECHANGER " .. self name .. " >"
  )
)