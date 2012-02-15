// silica programming language
// Jacob M. Peck
// REPL proto

if(?REPL_DEBUG, writeln("  + Loading REPL.io"))

silica REPL REPL := Object clone do(
  rl := ReadLine
  
  clone := method(self)
  
  initialize := method(
    self rl prompt = "silica> "
    self
  )
  
  loadHistory := method(
    try (
      self rl loadHistory(".silica_history")
    )
  )
  
  saveHistory := method(
    try (
      self rl saveHistory(".silica_history")
    )
  )
  
  run := method(
    loop(
      in := self rl readLine(self rl prompt);
      self rl addHistory(in);
      parse(in);
      if(silica exit, 
        self saveHistory;
        break
      )
    )
  )
  
  parse := method(in,
    processed := self preprocess(in)
    out := list("-->")
    if(processed == nil,
      writeln
      return
    )
    if(?REPL_DEBUG, writeln("TRACE (parse) received: " .. processed))
    processed splitNoEmpties foreach(tok,
      ret := silica TonalWorld interpretToken(tok asMutable lowercase)
      if(ret != nil, out append(ret))
    )
    if(out size == 1, out append("okay")) 
    writeln(out join(" "))
  )
  
  preprocess := method(in,
    out := in splitNoEmpties
    
    // macro definition?
    if(out at(1) == ">>",
      name := out at(0)
      contents := out rest rest join(" ")
      m := silica Macro with(name uppercase, contents)
      silica TokenTable add(silica TonalWorld currentNamespace, 
                            name lowercase, 
                            m
      )
      write("--> MACRO " .. silica TonalWorld currentNamespace .. "::" .. name uppercase .. " defined.")
      return nil
    )
    
    // command definition?
    if(out at(1) == "=", 
      name := out at(0)
      contents := out rest rest join(" ")
      c := silica Command with(name uppercase, contents)
      silica TokenTable add(silica TonalWorld currentNamespace, 
                            name lowercase, 
                            c
      )
      write("--> COMMAND " .. silica TonalWorld currentNamespace .. "::" .. name uppercase .. " defined.")
      return nil
    )
    
    // function definition?
    if(out at(1) == ":=", writeln("function"); return )
    
    // repetition and grouping factors
    changed := true
    while(changed,
      changed := false
      in_2 := out join(" ")
      out := list
      toks := in_2 splitNoEmpties
      toks foreach(tok,
        if(tok asNumber isNan,
          // not a repetition factor
          if(tok containsSeq("+"),
            // grouping factor
            changed = true
            out append(tok beforeSeq("+"))
            out append(tok afterSeq("+"))
            ,
            // not a grouping factor or repetition factor
            out append(tok)
          )
          ,
          // repetition factor
          changed = true
          num := tok asNumber
          info := tok afterSeq(num asString)
          num repeat(
            out append(info)
          )
        )
      )
    )
    if(?REPL_DEBUG, writeln("TRACE (preprocess) returning: " .. out join(" ")))
    out join(" ")
  )
)
