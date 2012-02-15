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

silica instrument := method(name,
  silica InstrumentTable get(name)
)

silica token := method(namespace, name,
  silica TokenTable get(namespace, name)
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
doFile("lang/TokenTable.io")
doFile("lang/Primitive.io")
doFile("lang/MetaCommand.io")
doFile("lang/Macro.io")
doFile("lang/Command.io")
doFile("lang/Function.io")
doFile("lang/Mode.io")
doFile("lang/Scale.io")
doFile("lang/Note.io")

// initialize everything
if(?REPL_DEBUG, writeln("Initializing language features..."))
  // initial modes
  if(?REPL_DEBUG, writeln("  + Initializing default modes..."))
  silica ModeTable new("MAJOR", list(2,2,1,2,2,2,1))
  silica ModeTable new("MINOR", list(2,1,2,2,1,2,2))
  
  // initial scales
  if(?REPL_DEBUG, writeln("  + Initializing default scales..."))
  silica ScaleTable new("C-MAJOR", silica mode("MAJOR"), "C")
  silica ScaleTable new("C-MINOR", silica mode("MINOR"), "C")
  
  // initialize the TokenTable
  if(?REPL_DEBUG, writeln("  + Initializing the token table..."))
  silica TokenTable initialize
  
  // initialize the Note
  if(?REPL_DEBUG, writeln("  + Initializing the note..."))
  silica Note reset
  
if(?REPL_DEBUG, writeln)