// silica programming language
// Jacob M. Peck
// silica namespace and language loader

silica := Object clone // namespace

// lookup methods
silica scale := method(name,
  silica ScaleTable get(name)
)

silica instrument := method(name,
  silica InstrumentTable get(name)
)

// load lang files
if(?REPL_DEBUG, writeln("Loading lang files..."))
Directory with("lang") filesWithExtension(".io") foreach(f,
  if(f name == "common.io", continue)
  if(?REPL_DEBUG, writeln("  + Loading " .. f name))
  doFile(f path)
)

// initialize everything
if(?REPL_DEBUG, writeln("Initializing language features..."))
silica Note reset
