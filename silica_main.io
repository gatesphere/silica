// silica programming language
// Jacob M. Peck
// the silica repl

SILICA_VERSION := "February 2012"
REPL_DEBUG := true

// welcome message
writeln("Welcome to silica!")
writeln("This is version: " .. SILICA_VERSION)

if(?REPL_DEBUG, writeln)

doRelativeFile("lang/common.io")
doRelativeFile("repl/common.io")
