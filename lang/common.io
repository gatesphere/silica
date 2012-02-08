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

silica macro := method(name,
  silica MacroTable get(name)
)

silica command := method(name,
  silica CommandTable get(name)
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

doFile("lang/EntityTable.io")
doFile("lang/Macro.io")
doFile("lang/Command.io")
doFile("lang/Scale.io")
doFile("lang/Note.io")

// initialize everything
if(?REPL_DEBUG, writeln("Initializing language features..."))
silica Note reset
