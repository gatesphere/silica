// silica namespace and language loader

silica := Object clone // namespace

// load lang files
Directory with("lang") filesWithExtension(".io") foreach(f,
  if(f name == "common.io", continue)
  if(REPL_DEBUG, writeln("Loading " .. f name))
  doFile(f path)
)
