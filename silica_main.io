// silica programming language
// Jacob M. Peck
// the silica repl

// globals
SILICA_VERSION := "March 2012"
REPL_MAX_RECURSIVE_DEPTH := 2000
REPL_RELOAD := true
REPL_LOAD_HISTORY := true
REPL_AUTOINVARIANT := false
REPL_SIREN_ENABLED := false
REPL_DEBUG := true

// welcome message
writeln("Welcome to silica!")
writeln("This is version: " .. SILICA_VERSION)

if(?REPL_DEBUG, writeln)

while(REPL_RELOAD,
  REPL_RELOAD = false
  doRelativeFile("lang/common.io")
  doRelativeFile("repl/common.io")
  if(?REPL_DEBUG, writeln("DEBUG: Done exiting.  REPL_RELOAD: " .. REPL_RELOAD))
)
