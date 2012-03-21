// silica programming language
// Jacob M. Peck
// home module - meta commands

if(?REPL_DEBUG, writeln("    + Initializing default meta commands..."))

home := silica namespace("home")
tt := silica TokenTable

tt add(home, "-siren", silica MetaCommand with("-SIREN", "Enable siren.",
    block(
      out := "-SIREN\n"
      if(Lobby ?REPL_SIREN_ENABLED,
        Lobby REPL_SIREN_ENABLED := false
        out = out .. "siren disabled."
        ,
        Lobby REPL_SIREN_ENABLED := true
        out = out .. "siren enabled."
      )
    )
))
tt add(home, "-silent", silica MetaCommand with("-SILENT", "Toggle all textual output.", 
    block(
      out := "-SILENT\n"
      if(silica REPL REPL silent, 
        silica REPL REPL silent = false
        out = out .. "Silent mode deactivated."
        ,
        silica REPL REPL silent = true
        out = out .. "Silent mode activated."
      )
      out
    )
))
tt add(home, "-exit", silica MetaCommand with("-EXIT", "Exit silica.", block(silica exit = true; "-EXIT")))
tt add(home, "-state", silica MetaCommand with("-STATE", "Print the state of the note.", block("-STATE\n" .. silica Note asString)))
tt add(home, "-reset", silica MetaCommand with("-RESET", "Reset the state of the note.", block("-RESET\n" .. silica Note reset)))
tt add(home, "-@?" , silica MetaCommand with("-@?", "Display information about the current namespace.",
    block(
      ns := silica REPL REPL currentNamespace
      out := "-@?\nCurrently in namespace \"" .. ns constructName .. "\"\n"
      if(ns parent == nil,
        out = out .. "This namespace is the root, and has no parent.\n"
        ,
        out = out .. "This namespace's parent is \"" .. ns parent constructName .. "\"\n"
      )
      if(ns children size == 0,
        out = out .. "This namespace contains no children."
        ,
        out = out .. "This namespace's children are:"
        ns children foreach(child,
          out = out .. "\n" .. "  " .. child constructName
        )
      )
      out
    )
))
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
tt add(home, "-reloadlang", silica MetaCommand with("-RELOADLANG", "Reload the silica language files.",
    block(
      Lobby REPL_RELOAD = true
      silica exit = true
      "-RELOADLANG"
    )
))
tt add(home, "-leave", silica MetaCommand with("-LEAVE", "Leave the current namespace, retreating one level up.",
    block(
      out := "-LEAVE\n"
      if(silica REPL REPL currentNamespace parent != nil,
        silica REPL REPL currentNamespace = silica REPL REPL currentNamespace parent
        out = out .. "Backing up, entering namespace \"" .. silica REPL REPL currentNamespace constructName .. "\"."
        ,
        out = out .. "Nowhere to go.  Remaining in namespace \"" .. silica REPL REPL currentNamespace constructName .. "\"."
      )
      out
    )
))
tt add(home, "-home", silica MetaCommand with("-HOME", "Return to the \"home\" namespace.", 
    block(
      out := "-HOME\n"
      silica REPL REPL currentNamespace = home
      out = out .. "Entering namespace \"" .. home constructName .. "\""
      out
    )
))
tt add(home, "-enter", silica MetaCommand with("-ENTER", "Enter the given namespace, automatically created if absent.",
    block(ns,
      out := "-ENTER\n"
      if(ns == nil,
        out = out .. "No namespace name provided."
        ,
        scns := silica REPL REPL currentNamespace
        namespace := silica namespace(scns constructName .. "::" .. ns)
        if(namespace == nil,
          silica NamespaceTable new(ns, scns)
          //writeln(ns)
          namespace := silica namespace(scns constructName .. "::" .. ns)
          //writeln(namespace)
          scns addChild(namespace)
          //writeln(scns children)
        )
        silica REPL REPL currentNamespace = namespace
        out = out .. "Entering namespace \"" .. namespace constructName .. "\""
      )
      out
    )
))
tt add(home, "-import", silica MetaCommand with("-IMPORT", "Run a file of silica instructions within the current namespace.",
    block(filename,
      if(filename != nil,
        file := File with(filename)
        if(file exists not,
          return "-IMPORT\nNo such file."
        )
        file openForReading
        writeln("Running script \"" .. file path .. "\".")
        loop(
          in := file readLine
          if(in == nil,
            break
          )
          if(in strip == "",
            continue
          )
          if(in strip beginsWithSeq("##") not, // lines beginning with ## are comments
            silica REPL REPL parse(in)
          )
        )
        file close
        writeln("--> DONE running script \"" .. file path .. "\".")
        "-IMPORT"
        ,
        "-IMPORT\nNo filename provided."
      )
    )
))
tt add(home, "-display", silica MetaCommand with("-DISPLAY", "Display the definition of a macro, command, or function.",
    block(tok,
      out := "-DISPLAY\n"
      symbols_already_defined := list
      symbols_to_define := list
      if(tok == nil,
        out = out .. "No symbol name provided."
        ,
        symbol := silica token(silica REPL REPL currentNamespace, tok)
        if(symbol == nil,
          out = out .. "No such symbol \"" .. tok .. "\" within namespace \"" .. silica REPL REPL currentNamespace constructName .. "\"."
          ,
          if(symbol isKindOf(silica Function),
            out = out .. symbol name .. "(" .. symbol params join(",") .. ") := " .. symbol value
            ,
            if(symbol isKindOf(silica Command),
              out = out .. symbol name .. " = " .. symbol value
              ,
              if(symbol isKindOf(silica Macro),
                out = out .. symbol name .. " >> " .. symbol value
                ,
                out = out .. "No such symbol \"" .. tok .. "\" within namespace \"" .. silica REPL REPL currentNamespace constructName .. "\"."
              )
            )
          )
        )
      )
      out
    )
))
tt add(home, "-s?", silica MetaCommand with("-S?", "Display the names and types of all macros, commands, and functions within the current namespace.",
    block(
      out := "-S?"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica Macro)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any token definitions."
          ,
          symbols foreach(tok,
            if(tok isKindOf(silica Function),
              out = out .. "\n" .. tok name .. " : function"
              ,
              if(tok isKindOf(silica Command),
                out = out .. "\n" .. tok name .. " : command"
                ,
                if(tok isKindOf(silica Macro),
                  out = out .. "\n" .. tok name .. " : macro"
                )
              )
            )
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any token definitions."
      )
      out
    )
))
tt add(home, "-s??", silica MetaCommand with("-S??", "Display the names and definitions of any macros, commands, and functions in the current namespace.",
    block(
      out := "-S??"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica Macro)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any token definitions."
          ,
          symbols foreach(tok,
            if(tok isKindOf(silica Function),
              out = out .. "\n" .. tok name .. "(" .. tok params join(",") .. ") := " .. tok value
              ,
              if(tok isKindOf(silica Command),
                out = out .. "\n" .. tok name .. " = " .. tok value
                ,
                if(tok isKindOf(silica Macro),
                  out = out .. "\n" .. tok name .. " >> " .. tok value
                )
              )
            )
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any token definitions."
      )
      out
    )
))
tt add(home, "-p?", silica MetaCommand with("-P?", "Display the names of any primitives in the current namespace.",
    block(
      out := "-P?"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica Primitive) and tok isKindOf(silica MetaCommand) not and tok isKindOf(silica ScaleChanger) not and tok isKindOf(silica InstrumentChanger) not) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any primitive definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any primitive definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-p??", silica MetaCommand with("-P??", "Display the names and descriptions of any primitives in the current namespace.",
    block(
      out := "-P??"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica Primitive) and tok isKindOf(silica MetaCommand) not and tok isKindOf(silica ScaleChanger) not and tok isKindOf(silica InstrumentChanger) not) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any primitive definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name .. " => " .. tok description
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any primitive definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-scales?", silica MetaCommand with("-SCALES?", "Display the names of any scales in the current namespace.",
    block(
      out := "-SCALES?"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica ScaleChanger)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any scale definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any scale definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-scales??", silica MetaCommand with("-SCALES??", "Display the names and descriptions of any scales in the current namespace.",
    block(
      out := "-SCALES??"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica ScaleChanger)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any scale definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name .. " => " .. tok description
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any scale definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-modes?", silica MetaCommand with("-MODES?", "Display the names of all scale modes currently recognized by silica.",
    block(
      out := "-MODES?"
      silica ModeTable table values sortBy(block(a, b, a name < b name)) foreach(m,
        out = out .. "\n" .. m name
      )
      out
    )
))
tt add(home, "-modes??", silica MetaCommand with("-MODES??", "Display the names and intervals of all scale modes currently recognized by silica.",
    block(
      out := "-MODES??"
      silica ModeTable table values sortBy(block(a, b, a name < b name)) foreach(m,
        out = out .. "\n" .. m name .. " => " .. m intervals join(" ")
      )
      out
    )
))
tt add(home, "-instruments?", silica MetaCommand with("-INSTRUMENTS?", "Display the names of any instruments in the current namespace.",
    block(
      out := "-INSTRUMENTS?"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica InstrumentChanger)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any instrument definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any instrument definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-instruments??", silica MetaCommand with("-INSTRUMENTS??", "Display the names and descriptions of any instruments in the current namespace.",
    block(
      out := "-INSTRUMENTS??"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica InstrumentChanger)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any instrument definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name .. " => " .. tok description
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any instrument definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-mc?", silica MetaCommand with("-MC?", "Display the names of any meta commands in the current namespace.",
    block(
      out := "-MC?"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica MetaCommand)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any meta command definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any meta command definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-mc??", silica MetaCommand with("-MC??", "Display the names and descriptions of any meta commands in the current namespace.",
    block(
      out := "-MC??"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica MetaCommand)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any meta command definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name .. " => " .. tok description
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any meta command definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-t?", silica MetaCommand with("-T?", "Display the names of any transforms in the current namespace.",
    block(
      out := "-T?"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica Transform)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any transform definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any transform definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-t??", silica MetaCommand with("-T??", "Display the names and definitions of any transforms in the current namespace.",
    block(
      out := "-T??"
      ns := silica REPL REPL currentNamespace
      token_table := tt namespace_table at(ns constructName)
      if(token_table != nil,
        symbols := token_table values select(tok, tok isKindOf(silica Transform)) sortBy(block(a , b, a name < b name))
        if(symbols size == 0,
          out = out .. "\nThis namespace doesn't contain any transform definitions.\nCheck in the \"home\" namespace."
          ,
          symbols foreach(tok,
            out = out .. "\n" .. tok name .. " => " .. tok description
          )
        )
        ,
        out = out .. "\nThis namespace doesn't contain any transform definitions.\nCheck in the \"home\" namespace."
      )
      out
    )
))
tt add(home, "-delete", silica MetaCommand with("-DELETE", "Delete the definition of the given symbol within the current namespace.",
    block(tok,
      out := "-DELETE\n"
      if(tok == nil,
        out = out .. "No symbol name provided."
        ,
        symbol := silica token(silica REPL REPL currentNamespace, tok lowercase)
        if(symbol == nil,
          out = out .. "No symbol \"" .. tok .. "\" defined in namespace \"" .. silica REPL REPL currentNamespace constructName .. "\"."
          ,
          if(symbol isKindOf(silica MetaCommand),
            silica TokenTable remove(silica REPL REPL currentNamespace, tok lowercase)
            out = out .. "Removing symbol \"" .. tok .. "\" from namespace \"" .. silica REPL REPL currentNamespace constructName .. "\"."
            ,
            out = out .. "Cannot remove symbol \"" .. tok .. "\": silica foundation feature."
          )
        )
        out
      )
    )
))
tt add(home, "-invariant", silica MetaCommand with("-INVARIANT", "Toggle auto-invariant mode.",
    block(
      out := "-INVARIANT\n"
      if(Lobby ?REPL_AUTOINVARIANT, 
        Lobby REPL_AUTOINVARIANT := false
        out = out .. "Auto-invariance mode deactivated."
        ,
        Lobby REPL_AUTOINVARIANT := true
        out = out .. "Auto-invariance mode activated."
      )
      out
    )
))
tt add(home, "-about", silica MetaCommand with("-ABOUT", "Display information about silica.",
    block(
      out := "-ABOUT\n"
      out = out .. "silica, copyright Jacob Peck, 2012.\nThis is version: " .. SILICA_VERSION .. "\n"
      out = out .. "For more information, please visit http://silica.suspended-chord.info/"
      out
    )
))