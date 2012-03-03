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

silica initializeScales := method(
  silica ModeTable table values foreach(mode,
    silica PitchNames foreach(tonic,
      silica ScaleTable new(tonic .. "-" .. mode name, mode, tonic)
    )
  )
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
  // initial modes
  if(?REPL_DEBUG, writeln("  + Initializing default modes..."))
  // 12-tone modes
  silica ModeTable new("CHROMATIC", list(1,1,1,1,1,1,1,1,1,1,1,1))
  // 8-tone modes
  silica ModeTable new("DIMINISHED", list(2,1,2,1,2,1,2,1))
  silica ModeTable new("HALFWHOLEDIMINISHED", list(1,2,1,2,1,2,1,2))
  // 7-tone modes
  silica ModeTable new("MAJOR", list(2,2,1,2,2,2,1))
  silica ModeTable new("MINOR", list(2,1,2,2,1,2,2))
  silica ModeTable new("HARMONICMINOR", list(2,1,2,2,1,3,1))
  silica ModeTable new("DORIAN", list(2,1,2,2,2,1,2))
  silica ModeTable new("PHRYGIAN", list(1,2,2,2,1,2,2))
  silica ModeTable new("LYDIAN", list(2,2,2,1,2,2,1))
  silica ModeTable new("MIXOLYDIAN", list(2,2,1,2,2,1,2))
  silica ModeTable new("LOCRIAN", list(1,2,2,1,2,2,2))
  // 6-tone modes
  silica ModeTable new("WHOLETONE", list(2,2,2,2,2,2))
  silica ModeTable new("BLUES", list(3,2,1,1,3,2))
  // 5-tone modes
  silica ModeTable new("PENTAMAJOR", list(2,2,3,2,3))
  silica ModeTable new("PENTAMINOR", list(3,3,1,3,2))
  // 3-tone modes (triads)
  silica ModeTable new("MAJORTIRAD", list(4,3,5))
  silica ModeTable new("MINORTRIAD", list(3,4,5))
  silica ModeTable new("DIMINISHEDTRIAD", list(3,3,6))
  silica ModeTable new("AUGMENTEDTRIAD", list(4,4,4))
  
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