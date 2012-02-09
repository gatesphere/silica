// silica programming language
// Jacob M. Peck
// Command proto

if(?REPL_DEBUG, writeln("  + Loading Command.io"))

silica Command := silica Macro clone do(
  expand := method(
    "{ " .. self value .. " }"
  )
)