// silica programming language
// Jacob M. Peck
// debug module - meta commands

if(?REPL_DEBUG, writeln("    + Initializing module:debug meta commands..."))

home := silica namespace("home")
tt := silica TokenTable

tt add(home, "-debug", silica MetaCommand with("-DEBUG", "Toggle debugging output.",
    block(
      out := "-DEBUG\n"
      if(Lobby ?REPL_DEBUG, 
        Lobby REPL_DEBUG := false
        out = out .. "Debug mode deactivated."
        ,
        Lobby REPL_DEBUG := true
        out = out .. "Debug mode activated."
      )
      out
    )
))
tt add(home, "-debugtime", silica MetaCommand with("-DEBUGTIME", "Toggle display of parse time.",
    block(
      out := "-DEBUGTIME\n"
      if(Lobby ?REPL_DEBUGTIME,
        Lobby REPL_DEBUGTIME := false
        out = out .. "Debug time deactivated."
        ,
        Lobby REPL_DEBUGTIME := true
        out = out .. "Debug time activated."
      )
      out
    )
))    
tt add(home, "-reloadlang", silica MetaCommand with("-RELOADLANG", "Reload the silica language files.",
    block(
      Lobby REPL_RELOAD = true
      silica exit = true
      "-RELOADLANG"
    )
))