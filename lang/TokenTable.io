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
  
  initialize := method(
    home := silica namespace("home")
    
    // primitives
    self add(home, "play", silica Primitive with("PLAY", block(silica Note play)))
    self add(home, "rest", silica Primitive with("REST", block(silica Note rest)))
    self add(home, "mute", silica Primitive with("MUTE", block(silica Note mute)))
    self add(home, "rp", silica Primitive with("RP", block(silica Note rp)))
    self add(home, "lp", silica Primitive with("LP", block(silica Note lp)))
    self add(home, "cp", silica Primitive with("CP", block(silica Note cp)))
    self add(home, "x2", silica Primitive with("X2", block(silica Note x2)))
    self add(home, "x3", silica Primitive with("X3", block(silica Note x3)))
    self add(home, "x5", silica Primitive with("X5", block(silica Note x5)))
    self add(home, "x7", silica Primitive with("X7", block(silica Note x7)))
    self add(home, "s2", silica Primitive with("S2", block(silica Note s2)))
    self add(home, "s3", silica Primitive with("S3", block(silica Note s3)))
    self add(home, "s5", silica Primitive with("S5", block(silica Note s5)))
    self add(home, "s7", silica Primitive with("S7", block(silica Note s7)))
    self add(home, "pushstate", silica Primitive with("PUSHSTATE", block(silica Note pushstate)))
    self add(home, "popstate", silica Primitive with("POPSTATE", block(silica Note popstate)))
    self add(home, "removestate", silica Primitive with("REMOVESTATE", block(silica Note removestate)))
    self add(home, "popalphabet", silica Primitive with("POPALPHABET", block(silica Note popalphabetRelative)))
    self add(home, "popalphabet$", silica Primitive with("POPALPHABET$", block(silica Note popalphabet)))
    
    // scales
    silica ScaleTable table values foreach(scale,
      name := scale name
      ctx := Object clone
      ctx x := scale
      self add(
        home, 
        (name .. "$") asMutable lowercase, 
        silica Primitive with(name .. "$" asMutable uppercase, 
            block(
              silica Note changeScale(x)
            ) setScope(ctx)
      ))
      self add(
        home, 
        name asMutable lowercase, 
        silica Primitive with(name asMutable uppercase, 
            block(
              silica Note changeScaleRelative(x)
            ) setScope(ctx)
      ))
    )
    self add(home, "chromatic", silica Primitive with("CHROMATIC",
        block(
          tonic := silica Note scale last getNameForDegree(silica Note degree)
          silica Note changeScaleRelative(silica scale(tonic .. "-CHROMATIC"))
        )
    ))
    
    
    // metas
    self add(home, "-exit", silica MetaCommand with("-EXIT", block(silica exit = true; "-EXIT")))
    self add(home, "-state", silica MetaCommand with("-STATE", block("-STATE\n" .. silica Note asString)))
    self add(home, "-reset", silica MetaCommand with("-RESET", block("-RESET\n" .. silica Note reset asString)))
    self add(home, "-@?" , silica MetaCommand with("-@?", 
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
    self add(home, "-debug", silica MetaCommand with("-DEBUG", 
        block(
          if(Lobby ?REPL_DEBUG, 
            Lobby REPL_DEBUG := false
            ,
            Lobby REPL_DEBUG := true
          )
          "-DEBUG"
        )
    ))
    self add(home, "-reloadlang", silica MetaCommand with("-RELOADLANG",
        block(
          Lobby REPL_RELOAD = true
          silica exit = true
          "-RELOADLANG"
        )
    ))
    self add(home, "-leave", silica MetaCommand with("-LEAVE", 
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
    self add(home, "-home", silica MetaCommand with("-HOME",
        block(
          out := "-HOME\n"
          silica REPL REPL currentNamespace = home
          out = out .. "Entering namespace \"" .. home constructName .. "\""
          out
        )
    ))
    self add(home, "-enter", silica MetaCommand with("-ENTER",
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
    self add(home, "-import", silica MetaCommand with("-IMPORT",
        block(filename,
          if(filename != nil,
            file := File with(filename) openForReading
            writeln("Running script \"" .. file path .. "\".")
            loop(
              in := file readLine
              if(in == nil,
                break;
              )
              if(in strip == "",
                continue;
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
    self add(home, "-display", silica MetaCommand with("-DISPLAY",
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
                out = out .. symbol name.. "(" .. symbol params join(",") .. ") := " .. symbol value
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
    self add(home, "-s?", silica MetaCommand with("-S?",
        block(
          out := "-S?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table != nil,
            symbols := token_table values select(tok, tok isKindOf(silica Macro))
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
    self add(home, "-s??", silica MetaCommand with("-S??",
        block(
          out := "-S??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table != nil,
            symbols := token_table values select(tok, tok isKindOf(silica Macro))
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
    self add(home, "-p?", silica MetaCommand with("-P?",
        block(
          out := "-P?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table != nil,
            symbols := token_table values select(tok, tok isKindOf(silica Primitive) and tok isKindOf(silica MetaCommand) not)
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
    self add(home, "-mc?", silica MetaCommand with("-MC?",
        block(
          out := "-MC?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table != nil,
            symbols := token_table values select(tok, tok isKindOf(silica MetaCommand))
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
    self add(home, "-t?", silica MetaCommand with("-T?",
        block(
          out := "-T?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table != nil,
            symbols := token_table values select(tok, tok isKindOf(silica Transform))
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
    self add(home, "-about", silica MetaCommand with("-ABOUT",
        block(
          out := "-ABOUT\n"
          out = out .. "silica, copyright Jacob Peck, 2012.\nThis is version: " .. SILICA_VERSION .. "\n"
          out = out .. "For more information, please visit http://silica.suspended-chord.info/"
          out
        )
    ))
        
    // transforms
    self add(home, ":drop", silica Transform with(":DROP",
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
    self add(home, ":invert", silica Transform with(":INVERT", // contour invert
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
  )
  
  
  
  asString := method(
    "< TOKENTABLE >"
  )
)
