// silica programming language
// Jacob M. Peck
// home module loader

if(?REPL_DEBUG, writeln("  + Loading module \"home\"..."))

list(
  "primitives.io",
  "modes.io",
  "scales.io",
  "instruments.io",
  "metacommands.io",
  "transforms.io"
) foreach(f, doRelativeFile(f))
