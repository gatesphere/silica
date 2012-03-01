// silica programming language
// Jacob M. Peck
// silica namespace and language loader

silica := Object clone // namespace

// lookup methods
silica mode := method(name,
  silica ModeTable get(name)
)

silica scale := method(name,
  silica ScaleTable get(name)
)

/*
silica instrument := method(name,
  silica InstrumentTable get(name)
)
*/

silica namespace := method(name,
  silica NamespaceTable get(name)
)

silica token := method(namespace, name,
  silica TokenTable get(namespace, name)
)

silica initializeScales := method(
  silica ModeTable table values foreach(mode,
    silica PitchNames foreach(tonic,
      silica ScaleTable new(tonic .. "-" .. mode name, mode, tonic)
    )
  )
)

// load lang files

if(?REPL_DEBUG, writeln("Loading lang files..."))
/* fix this later
Directory with("lang") filesWithExtension(".io") foreach(f,
  if(f name == "common.io", continue)
  if(?REPL_DEBUG, writeln("  + Loading " .. f name))
  doFile(f path)
)
*/

doRelativeFile("EntityTable.io")
doRelativeFile("Namespace.io")
doRelativeFile("TokenTable.io")
doRelativeFile("Primitive.io")
doRelativeFile("MetaCommand.io")
doRelativeFile("Macro.io")
doRelativeFile("Command.io")
doRelativeFile("Function.io")
doRelativeFile("Mode.io")
doRelativeFile("Scale.io")
doRelativeFile("Note.io")
doRelativeFile("Transform.io")

// initialize everything
if(?REPL_DEBUG, writeln("Initializing language features..."))
  // initial modes
  if(?REPL_DEBUG, writeln("  + Initializing default modes..."))
  silica ModeTable new("MAJOR", list(2,2,1,2,2,2,1))
  silica ModeTable new("MINOR", list(2,1,2,2,1,2,2))
  silica ModeTable new("HARMONICMINOR", list(2,1,2,2,1,3,1))
  silica ModeTable new("CHROMATIC", list(1,1,1,1,1,1,1,1,1,1,1,1))
  silica ModeTable new("WHOLETONE", list(2,2,2,2,2,2))
  silica ModeTable new("PENTAMAJOR", list(2,2,3,2,3))
  silica ModeTable new("PENTAMINOR", list(3,3,1,3,2))
  silica ModeTable new("BLUES", list(3,2,1,1,3,2))
  silica ModeTable new("DORIAN", list(2,1,2,2,2,1,2))
  silica ModeTable new("PHRYGIAN", list(1,2,2,2,1,2,2))
  
  // initial scales
  if(?REPL_DEBUG, writeln("  + Initializing default scales..."))
  silica initializeScales

  
  // initialize the TokenTable
  if(?REPL_DEBUG, writeln("  + Initializing the token table..."))
  silica TokenTable initialize
  
  // initialize the Note
  if(?REPL_DEBUG, writeln("  + Initializing the note..."))
  silica Note reset
  
if(?REPL_DEBUG, writeln)