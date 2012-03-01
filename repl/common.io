// silica programming language
// Jacob M. Peck
// silica REPL namespace and loader

silica REPL := Object clone // namespace

// load REPL files
if(?REPL_DEBUG, writeln("Loading REPL files..."))

silica replFileList := list(
  "REPL.io"
)

silica replFileList foreach(f,
  doRelativeFile(f)
)

// initialize everything
if(?REPL_DEBUG, writeln("Initializing REPL..."))
  if(?REPL_DEBUG, writeln("  + Initializing prompt..."))
  silica REPL REPL initialize

  if(?REPL_DEBUG, writeln("  + Loading REPL command history..."))
  if(REPL_LOAD_HISTORY,
    silica REPL REPL loadHistory
    REPL_LOAD_HISTORY = false
  )

  if(?REPL_DEBUG, writeln("  + Starting REPL..."))
  silica exit := false
  silica REPL REPL run(SCRIPT_FILE)
  if(?REPL_DEBUG, writeln("  + Exiting..."))
