// silica REPL namespace and loader

silica REPL := Object clone // namespace

// load lang files
Directory with("repl") filesWithExtension(".io") foreach(f,
  if(f name == "common.io", continue)
  if(REPL_DEBUG, writeln("Loading " .. f name))
  doFile(f path)
)
