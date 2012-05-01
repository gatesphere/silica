// silica programming language
// Jacob M. Peck
// debug module loader

if(?REPL_DEBUG, writeln("  + Loading module \"debug\"..."))

list(
  "metacommands.io"
) foreach(f, doRelativeFile(f))
