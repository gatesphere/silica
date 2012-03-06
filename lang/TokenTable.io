// silica programming language
// Jacob M. Peck
// TokenTable proto

if(?REPL_DEBUG, writeln("  + Loading TokenTable.io"))

silica TokenTable := Object clone do(
  namespace_table := Map clone
  
  clone := method(self)

  get := method(namespace, name,
    token_table := self namespace_table at(namespace constructName)
    if(token_table != nil,
      return token_table at(name),
      return nil
    )
  )
    
  add := method(namespace, name, token,
    token_table := self namespace_table atIfAbsentPut(namespace constructName, Map clone)
    token_table atPut(name, token)
    self
  )
  
  remove := method(namespace, name,
    token_table := self namespace_table atIfAbsentPut(namespace constructName, Map clone)
    token_table removeAt(name)
    self
  )
  
  initialize := method(
    home := silica namespace("home")
    
    // primitives
    self add(home, "play", silica Primitive with("PLAY", "Plays the note with the current state.", block(silica Note play)))
    self add(home, "rest", silica Primitive with("REST", "Rests the note for the current duration.", block(silica Note rest)))
    //self add(home, "mute", silica Primitive with("MUTE", "Plays a muted note for the current duration.", block(silica Note mute)))
    self add(home, "rp", silica Primitive with("RP", "Raises the pitch of the note by one scale degree.", block(silica Note rp)))
    self add(home, "lp", silica Primitive with("LP", "Lowers the pitch of the note by one scale degree.", block(silica Note lp)))
    self add(home, "cp", silica Primitive with("CP", "Stochastically applies either RP or LP.", block(silica Note cp)))
    self add(home, "x2", silica Primitive with("X2", "Expands the current duration by a factor of 2", block(silica Note x2)))
    self add(home, "x3", silica Primitive with("X3", "Expands the current duration by a factor of 3", block(silica Note x3)))
    self add(home, "x5", silica Primitive with("X5", "Expands the current duration by a factor of 5", block(silica Note x5)))
    self add(home, "x7", silica Primitive with("X7", "Expands the current duration by a factor of 7", block(silica Note x7)))
    self add(home, "s2", silica Primitive with("S2", "Shrinks the current duration by a factor of 2", block(silica Note s2)))
    self add(home, "s3", silica Primitive with("S3", "Shrinks the current duration by a factor of 3", block(silica Note s3)))
    self add(home, "s5", silica Primitive with("S5", "Shrinks the current duration by a factor of 5", block(silica Note s5)))
    self add(home, "s7", silica Primitive with("S7", "Shrinks the current duration by a factor of 7", block(silica Note s7)))
    self add(home, "pushstate", silica Primitive with("PUSHSTATE", "Pushes the current state of the note onto the statestack.", block(silica Note pushstate)))
    self add(home, "popstate", silica Primitive with("POPSTATE", "Pops the top state of the statestack off and applies it to the note.", block(silica Note popstate)))
    self add(home, "removestate", silica Primitive with("REMOVESTATE", "Removes the top state of the statestack without applying it to the note.", block(silica Note removestate)))
    self add(home, "popalphabet", silica Primitive with("POPALPHABET", "Attempts to relatively pop and apply the top alphabet from the scalestack.", block(silica Note popalphabetRelative)))
    self add(home, "popalphabet$", silica Primitive with("POPALPHABET$", "Absolutely pops the top alphabet from the scalestack.", block(silica Note popalphabet)))
    self add(home, "maxvol", silica Primitive with("MAXVOL", "Sets the volume to the maximum (16000).", block(silica Note maxvol)))
    self add(home, "minvol", silica Primitive with("MINVOL", "Sets the volume to the minimum (0).", block(silica Note minvol)))
    self add(home, "midvol", silica Primitive with("MIDVOL", "Sets the volume to a mid-range value (8000).", block(silica Note midvol)))
    self add(home, "startvol", silica Primitive with("STARTVOL", "Sets the volume to the starting value (12000).", block(silica Note startvol)))
    self add(home, "incvol", silica Primitive with("INCVOL", "Increments the volume by 1000.", block(silica Note incvol)))
    self add(home, "incvol1", silica Primitive with("INCVOL1", "Increments the volume by 100.", block(silica Note incvol1)))
    self add(home, "decvol", silica Primitive with("DECVOL", "Decrements the volume by 1000.", block(silica Note decvol)))
    self add(home, "decvol1", silica Primitive with("DECVOL1", "Decrements the volume by 100.", block(silica Note decvol1)))
    self add(home, "maxtempo", silica Primitive with("MAXTEMPO", "Sets the tempo to the maximum (400 bpm).", block(silica Note maxtempo)))
    self add(home, "mintempo", silica Primitive with("MINTEMPO", "Sets the tempo to the minimum (20 bpm).", block(silica Note mintempo)))
    self add(home, "midtempo", silica Primitive with("MIDTEMPO", "Sets the tempo to a mid-range value (190 bpm).", block(silica Note midtempo)))
    self add(home, "starttempo", silica Primitive with("STARTTEMPO", "Sets the tempo to the starting value (120 bpm).", block(silica Note starttempo)))
    self add(home, "doubletempo", silica Primitive with("DOUBLETEMPO", "Doubles the tempo.", block(silica Note doubletempo)))
    self add(home, "tripletempo", silica Primitive with("TRIPLETEMPO", "Triples the tempo.", block(silica Note tripletempo)))
    self add(home, "halftempo", silica Primitive with("HALFTEMPO", "Halves the tempo.", block(silica Note halftempo)))
    self add(home, "thirdtempo", silica Primitive with("THIRDTEMPO", "Thirds the tempo.", block(silica Note thirdtempo)))
    self add(home, "inctempo", silica Primitive with("INCTEMPO", "Increments the tempo by 10 bpm.", block(silica Note inctempo)))
    self add(home, "inctempo1", silica Primitive with("INCTEMPO1", "Increments the tempo by 1 bpm.", block(silica Note inctempo1)))
    self add(home, "dectempo", silica Primitive with("DECTEMPO", "Decrements the tempo by 10 bpm.", block(silica Note dectempo)))
    self add(home, "dectempo1", silica Primitive with("DECTEMPO1", "Decrements the tempo by 1 bpm.", block(silica Note dectempo1)))

    // scales
    silica ScaleTable table values foreach(scale,
      name := scale name
      ctx := Object clone
      ctx x := scale
      self add(
        home, 
        (name .. "$") asMutable lowercase, 
        silica ScaleChanger with(name .. "$" asMutable uppercase, 
            "Attempts to relatively push the scale " .. name .. " onto the scalestack.", 
            block(
              silica Note changeScale(x)
            ) setScope(ctx)
      ))
      self add(
        home, 
        name asMutable lowercase, 
        silica ScaleChanger with(name asMutable uppercase, 
            "Absolutely pushes the scale " .. name .. " onto the scalestack.", 
            block(
              silica Note changeScaleRelative(x)
            ) setScope(ctx)
      ))
    )
    self add(home, "chromatic", silica Primitive with("CHROMATIC",
        "Relatively pushes the chromatic scale matching the note's current pitch class onto the scalestack.",
        block(
          tonic := silica Note scale last getNameForDegree(silica Note degree)
          silica Note changeScaleRelative(silica scale(tonic .. "-CHROMATIC"))
        )
    ))
    
    // instruments
    silica InstrumentTable table values foreach(instrument,
      name := instrument name
      ctx := Object clone
      ctx x := instrument
      self add(
        home,
        name asMutable lowercase,
        silica InstrumentChanger with(name asMutable uppercase,
            "Changes the current instrument to " .. name .. ".",
            block(
              silica Note changeInstrument(x)
            ) setScope(ctx)
      ))
    )
    
    
    // metas
    self add(home, "-siren", silica MetaCommand with("-SIREN", "Enable siren.",
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
    self add(home, "-exit", silica MetaCommand with("-EXIT", "Exit silica.", block(silica exit = true; "-EXIT")))
    self add(home, "-state", silica MetaCommand with("-STATE", "Print the state of the note.", block("-STATE\n" .. silica Note asString)))
    self add(home, "-reset", silica MetaCommand with("-RESET", "Reset the state of the note.", block("-RESET\n" .. silica Note reset asString)))
    self add(home, "-@?" , silica MetaCommand with("-@?", "Display information about the current namespace.",
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
    self add(home, "-debug", silica MetaCommand with("-DEBUG", "Toggle debugging output.",
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
    self add(home, "-reloadlang", silica MetaCommand with("-RELOADLANG", "Reload the silica language files.",
        block(
          Lobby REPL_RELOAD = true
          silica exit = true
          "-RELOADLANG"
        )
    ))
    self add(home, "-leave", silica MetaCommand with("-LEAVE", "Leave the current namespace, retreating one level up.",
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
    self add(home, "-home", silica MetaCommand with("-HOME", "Return to the \"home\" namespace.", 
        block(
          out := "-HOME\n"
          silica REPL REPL currentNamespace = home
          out = out .. "Entering namespace \"" .. home constructName .. "\""
          out
        )
    ))
    self add(home, "-enter", silica MetaCommand with("-ENTER", "Enter the given namespace, automatically created if absent.",
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
    self add(home, "-import", silica MetaCommand with("-IMPORT", "Run a file of silica instructions within the current namespace.",
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
              silica REPL REPL parse(in)
            )
            file close
            writeln("--> DONE running script \"" .. file path .. "\".")
            "-IMPORT"
            ,
            "-IMPORT\nNo filename provided."
          )
        )
    ))
    self add(home, "-display", silica MetaCommand with("-DISPLAY", "Display the definition of a macro, command, or function.",
        block(tok,
          out := "-DISPLAY\n"
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
    self add(home, "-s?", silica MetaCommand with("-S?", "Display the names and types of all macros, commands, and functions within the current namespace.",
        block(
          out := "-S?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-s??", silica MetaCommand with("-S??", "Display the names and definitions of any macros, commands, and functions in the current namespace.",
        block(
          out := "-S??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-p?", silica MetaCommand with("-P?", "Display the names of any primitives in the current namespace.",
        block(
          out := "-P?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-p??", silica MetaCommand with("-P??", "Display the names and descriptions of any primitives in the current namespace.",
        block(
          out := "-P??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-scales?", silica MetaCommand with("-SCALES?", "Display the names of any scales in the current namespace.",
        block(
          out := "-SCALES?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-scales??", silica MetaCommand with("-SCALES??", "Display the names and descriptions of any scales in the current namespace.",
        block(
          out := "-SCALES??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-modes?", silica MetaCommand with("-MODES?", "Display the names of all scale modes currently recognized by silica.",
        block(
          out := "-MODES?"
          silica ModeTable table values sortBy(block(a, b, a name < b name)) foreach(m,
            out = out .. "\n" .. m name
          )
          out
        )
    ))
    self add(home, "-modes??", silica MetaCommand with("-MODES??", "Display the names and intervals of all scale modes currently recognized by silica.",
        block(
          out := "-MODES??"
          silica ModeTable table values sortBy(block(a, b, a name < b name)) foreach(m,
            out = out .. "\n" .. m name .. " => " .. m intervals join(" ")
          )
          out
        )
    ))
    self add(home, "-instruments?", silica MetaCommand with("-INSTRUMENTS?", "Display the names of any instruments in the current namespace.",
        block(
          out := "-INSTRUMENTS?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-instruments??", silica MetaCommand with("-INSTRUMENTS??", "Display the names and descriptions of any instruments in the current namespace.",
        block(
          out := "-INSTRUMENTS??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-mc?", silica MetaCommand with("-MC?", "Display the names of any meta commands in the current namespace.",
        block(
          out := "-MC?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-mc??", silica MetaCommand with("-MC??", "Display the names and descriptions of any meta commands in the current namespace.",
        block(
          out := "-MC??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-t?", silica MetaCommand with("-T?", "Display the names of any transforms in the current namespace.",
        block(
          out := "-T?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-t??", silica MetaCommand with("-T??", "Display the names and definitions of any transforms in the current namespace.",
        block(
          out := "-T??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
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
    self add(home, "-delete", silica MetaCommand with("-DELETE", "Delete the definition of the given symbol within the current namespace.",
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
    self add(home, "-invariant", silica MetaCommand with("-INVARIANT", "Toggle auto-invariant mode.",
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
    self add(home, "-about", silica MetaCommand with("-ABOUT", "Display information about silica.",
        block(
          out := "-ABOUT\n"
          out = out .. "silica, copyright Jacob Peck, 2012.\nThis is version: " .. SILICA_VERSION .. "\n"
          out = out .. "For more information, please visit http://silica.suspended-chord.info/"
          out
        )
    ))
        
    // transforms
    self add(home, ":drop", silica Transform with(":DROP", "Removes the last note of whatever it is applied to.",
        block(in, scale,
          in_l := in splitNoEmpties
          pos := in_l size - 1
          loop(
            if(pos < 0, break)
            tok := in_l at(pos)
            if(tok == "play" or tok == "mute" or tok == "rest",
              in_l removeAt(pos)
              break
              ,
              pos = pos - 1
            )
          )
          in_l join(" ")
        )
    ))
    self add(home, ":double", silica Transform with(":DOUBLE", "Doubles the last note of whatever it is applied to.",
        block(in, scale,
          in_l := in splitNoEmpties
          pos := in_l size - 1
          loop(
            if(pos < 0, break)
            tok := in_l at(pos)
            if(tok == "play" or tok == "mute" or tok == "rest",
              in_l atPut(pos, tok .. " " .. tok)
              break
              ,
              pos = pos - 1
            )
          )
          in_l join(" ")
        )
    ))
    self add(home, ":invert", silica Transform with(":INVERT", "Inverts the contour of whatever it is applied to.",
        block(in, scale,
          in splitNoEmpties map(tok,
            if(tok == "rp",
              "lp"
              ,
              if(tok == "lp",
              "rp"
                ,
                tok
              )
            )
          ) join(" ")
        )
    ))
    self add(home, ":retrograde", silica Transform with(":RETROGRADE", "Reverses the order of whatever it is applied to.",
        block(in, scale, 
          // gather information
          contours := list
          durations := list
          play_commands := list
          curr_contour := 0 // relative
          curr_duration_stack := list
          curr_duration_recovery := list
          in splitNoEmpties foreach(tok,
            if(tok == "rp", curr_contour = curr_contour + 1)
            if(tok == "lp", curr_contour = curr_contour - 1)
            if(tok == "x2", curr_duration_stack append("x2"); curr_duration_recovery prepend("s2"))
            if(tok == "x3", curr_duration_stack append("x3"); curr_duration_recovery prepend("s3"))
            if(tok == "x5", curr_duration_stack append("x5"); curr_duration_recovery prepend("s5"))
            if(tok == "x7", curr_duration_stack append("x7"); curr_duration_recovery prepend("s7"))
            if(tok == "s2", curr_duration_stack append("s2"); curr_duration_recovery prepend("x2"))
            if(tok == "s3", curr_duration_stack append("s3"); curr_duration_recovery prepend("x3"))
            if(tok == "s5", curr_duration_stack append("s5"); curr_duration_recovery prepend("x5"))
            if(tok == "s7", curr_duration_stack append("s7"); curr_duration_recovery prepend("x7"))
            if(tok == "play" or tok == "rest" or tok == "mute",
              play_commands prepend(tok)
              contours prepend(curr_contour)
              durations prepend(list(curr_duration_stack clone, curr_duration_recovery clone))
            )
          )
          if(?REPL_DEBUG, writeln("TRACE (:retrograde): play_commands = " .. play_commands))
          if(?REPL_DEBUG, writeln("TRACE (:retrograde): contours = " .. contours))
          if(?REPL_DEBUG, writeln("TRACE (:retrograde): durations = " .. durations))
          
          // reverse
          out := list("pushstate")
          curr_contour = 0
          play_commands foreach(i, pc,
            target_contour := contours at(i)
            target_duration := durations at(i)
            // contour
            while(curr_contour != target_contour,
              if(curr_contour < target_contour,
                curr_contour = curr_contour + 1
                out append("rp")
                ,
                curr_contour = curr_contour - 1
                out append("lp")
              )
            )
            
            // duration
            out append(target_duration first join(" "))
            
            // play command
            out append(pc)
            
            // duration again
            out append(target_duration second join(" "))
          )
          out append("popstate")
          out join(" ")
        )
    ))
          
  )
  
  
  
  asString := method(
    "< TOKENTABLE >"
  )
)
