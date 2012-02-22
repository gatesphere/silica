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
    self add(home, "-enter", silica MetaCommand with("-ENTER",
        block(ns,
          out := "-ENTER\n"
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
          out
        )
    ))
    self add(home, "-import", silica MetaCommand with("-IMPORT",
        block(filename,
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
        )
    ))
    self add(home, "-s?", silica MetaCommand with("-S?",
        block(
          out := "-S?"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table == nil or token_table values size == 0,
            out = out .. "\nThis namespace doesn't contain any token definitions."
            ,
            token_table values foreach(tok,
              if(tok isKindOf(silica MetaCommand),
                out = out .. "\n" .. tok name .. " : meta command"
                ,
                if(tok isKindOf(silica Primitive),
                  out = out .. "\n" .. tok name .. " : primitive"
                  ,
                  if(tok isKindOf(silica Function),
                    out = out .. "\n" .. tok name .. " : function"
                    ,
                    if(tok isKindOf(silica Command),
                      out = out .. "\n" .. tok name .. " : command"
                      ,
                      if(tok isKindOf(silica Macro),
                        out = out .. "\n" .. tok name .. " : macro"
                        ,
                        out = out .. "\n" .. tok name .. " : unknown"
                      )
                    )
                  )
                )
              )
            )
          )
          out
        )
    ))
    self add(home, "-s??", silica MetaCommand with("-S??",
        block(
          out := "-S??"
          ns := silica REPL REPL currentNamespace
          token_table := self namespace_table at(ns constructName)
          if(token_table == nil or token_table values size == 0,
            out = out .. "\nThis namespace doesn't contain any token definitions."
            ,
            token_table values foreach(tok,
              if(tok isKindOf(silica MetaCommand),
                out = out .. "\n" .. tok name .. " : meta command"
                ,
                if(tok isKindOf(silica Primitive),
                  out = out .. "\n" .. tok name .. " : primitive"
                  ,
                  if(tok isKindOf(silica Function),
                    out = out .. "\n" .. tok name .. "(" .. tok params join(",") .. ") := " .. tok value
                    ,
                    if(tok isKindOf(silica Command),
                      out = out .. "\n" .. tok name .. " = " .. tok value
                      ,
                      if(tok isKindOf(silica Macro),
                        out = out .. "\n" .. tok name .. " >> " .. tok value
                        ,
                        out = out .. "\n" .. tok name .. " : unknown"
                      )
                    )
                  )
                )
              )
            )
          )
          out
        )
    ))
  )
  
  asString := method(
    "< TOKENTABLE >"
  )
)
