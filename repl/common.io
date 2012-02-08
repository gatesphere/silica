// silica programming language
// Jacob M. Peck
// silica REPL namespace and loader

silica REPL := Object clone // namespace

// load lang files
if(?REPL_DEBUG, writeln("Loading REPL files..."))
Directory with("repl") filesWithExtension(".io") foreach(f,
  if(f name == "common.io", continue)
  if(?REPL_DEBUG, writeln("  + Loading " .. f name))
  doFile(f path)
)

// initialize everything
if(?REPL_DEBUG, writeln("Initializing REPL..."))
