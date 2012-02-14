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
    processed splitNoEmpties foreach(tok,
      ret := silica TonalWorld interpretToken(tok asMutable lowercase)
      if(ret != nil, out append(ret))
    )
    if(out size == 1, out append("okay")) 
    writeln(out join(" "))
  )
  
  preprocess := method(in,
    toks := in splitNoEmpties
    
    // the following is a stub
    if(toks at(1) == ">>", writeln("macro"); return in)
    if(toks at(1) == "=", writeln("command"); return in)
    if(toks at(1) == ":=", writeln("function"); return in)
    // end stub
    
    // repetition factors
    out := list
    toks foreach(tok,
      if(tok asNumber isNan,
        out append(tok)
        ,
        num := tok asNumber
        info := tok afterSeq(num asString)
        num repeat(
          out append(info)
        )
      )
    )
    out join(" ")
  )
)
