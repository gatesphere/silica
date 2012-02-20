// silica programming language
// Jacob M. Peck
// silica REPL namespace and loader

silica REPL := Object clone // namespace

// load lang files
if(?REPL_DEBUG, writeln("Loading REPL files..."))

/*
Directory with("repl") filesWithExtension(".io") foreach(f,
  if(f name == "common.io", continue)
  if(?REPL_DEBUG, writeln("  + Loading " .. f name))
  doFile(f path)
)
*/

doFile("repl/REPL.io");

// initialize everything
if(?REPL_DEBUG, writeln("Initializing REPL..."))
  if(?REPL_DEBUG, writeln("  + Initializing prompt..."))
  silica REPL REPL initialize

  if(?REPL_DEBUG, writeln("  + Loading REPL command history..."))
  silica REPL REPL loadHistory

  if(?REPL_DEBUG, writeln("  + Starting REPL..."))
  silica exit := false
  silica REPL REPL run(SCRIPT_FILE)
