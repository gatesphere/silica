// silica programming language
// Jacob M. Peck
// silica namespace and language loader

silica := Object clone // namespace

////////////////////////////////////////////////////////////////////////////////
// File: Lang Globals
//
// Globally available methods from the Lang group

// Group: Lookup Methods
/* Method: mode(name)
 *
 * Gets the mode mapped to by name
 *
 * Parameters:
 *   name - key into mode table
 *
 * Returns:
 *   mode
 */
silica mode := method(name,
  silica ModeTable get(name)
)

/* Method: scale(name)
 *
 * Gets the scale mapped to by name
 *
 * Parameters:
 *   name - key into scale table
 *
 * Returns:
 *   scale
 */
silica scale := method(name,
  silica ScaleTable get(name)
)

/* Method: instrument(name)
 *
 * Gets the instrument mapped to by name
 *
 * Parameters:
 *   name - key into instrument table
 *
 * Returns:
 *   instrument
 */
silica instrument := method(name,
  silica InstrumentTable get(name)
)

/* Method: namespace(name)
 *
 * Gets the namespace mapped to by name
 *
 * Parameters:
 *   name - key into namespace table
 *
 * Returns:
 *   namespace
 */
silica namespace := method(name,
  silica NamespaceTable get(name)
)

/* Method: token(namespace, name)
 *
 * Gets the token mapped to by name within namespace
 *
 * Parameters:
 *   namespace - namespace to check within
 *   name - key into token table
 *
 * Returns:
 *   token
 */
silica token := method(namespace, name,
  silica TokenTable get(namespace, name)
)

/* Method: loadmodule(name)
 *
 * Loads the module with the provided name
 *
 * Parameters:
 *   name - the module to load
 *
 * Returns:
 *   boolean - true if load successful, false if otherwise
 */
silica loadmodule := method(name,
  p := Path with(SILICA_DIR, "modules", name, "main.io")
  f := File with(p)
  if(f exists,
    doFile(p)
    return true
    ,
    return false
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

  // load the "home" module
  silica loadmodule("home")
  
  // initialize the Note
  if(?REPL_DEBUG, writeln("  + Initializing the note..."))
  silica Note reset
  
if(?REPL_DEBUG, writeln)