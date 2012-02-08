// silica programming language
// Jacob M. Peck
// Command proto

if(?REPL_DEBUG, writeln("  + Loading Command.io"))

silica Command := silica Macro clone do(
  expand := method(
    "{ " .. self value .. " }"
  )
)

silica CommandTable := silica EntityTable clone do(
  clone := method(self)
  new := method(name, value,
    self table atIfAbsentPut(name, silica Command with(name, value))
  )
)