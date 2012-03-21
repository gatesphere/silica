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

silica namespace := method(name,
  silica NamespaceTable get(name)
)

silica token := method(namespace, name,
  silica TokenTable get(namespace, name)
)

// load lang files

if(?REPL_DEBUG, writeln("Loading lang files..."))

silica langFileList := list(
  "Entity.io",
  "EntityTable.io", 
  "Namespace.io",
  "TokenTable.io",
  "Primitive.io",
  "ScaleChanger.io",
  "InstrumentChanger.io",
  "MetaCommand.io",
  "Macro.io",
  "Command.io",
  "Function.io",
  "Mode.io",
  "Scale.io",
  "Instrument.io",
  "Note.io",
  "Transform.io"
)

silica langFileList foreach(f,
  doRelativeFile(f)
)

// initialize everything
if(?REPL_DEBUG, writeln("Initializing language features..."))

  // load the "home" module
  doRelativeFile("../modules/home/main.io")
  
  // initialize the Note
  if(?REPL_DEBUG, writeln("  + Initializing the note..."))
  silica Note reset
  
if(?REPL_DEBUG, writeln)