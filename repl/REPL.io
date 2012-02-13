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
      if(in == "exit", 
        self saveHistory;
        break
      )
    )
  )
  
  parse := method(in,
    writeln("--> I received: " .. in)
  )
)
