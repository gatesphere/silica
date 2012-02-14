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
    out := list("-->")
    in splitNoEmpties foreach(tok,
      ret := silica TonalWorld interpretToken(tok asMutable lowercase)
      if(ret != nil, out append(ret))
    )
    if(out size == 1, out append("okay")) 
    writeln(out join(" "))
  )
)
