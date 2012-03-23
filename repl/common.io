// silica programming language
// Jacob M. Peck
// silica REPL namespace and loader

silica REPL := Object clone // namespace

// load REPL files
if(?REPL_DEBUG, writeln("Loading REPL files..."))

silica replFileList := list(
  "Parser.io",
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

  if(?REPL_DEBUG, writeln("  + Autoexec..."))
  if(?AUTOEXEC,
    if(File with(AUTOEXEC) exists,
      if(?REPL_DEBUG, writeln("    + autoexec.silica found.  Loading..."))
      silica exit := false
      silica REPL REPL run(AUTOEXEC, true)
      ,
      if(?REPL_DEBUG, writeln("    + autoexec.silica not found.  Skipping..."))
    )
  )

  if(?REPL_DEBUG, writeln("  + Starting REPL..."))
  silica exit := false
  silica REPL REPL run(SCRIPT_FILE)
  if(?REPL_DEBUG, writeln("  + Exiting..."))
