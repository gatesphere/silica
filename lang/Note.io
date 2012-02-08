// silica programming language
// Jacob M. Peck
// Note proto

if(?REPL_DEBUG, writeln("  + Loading Note.io"))

silica Note := Object clone do(
  scale ::=  nil                     // C-Major scale
  degree ::= 1                       // scale degree
  duration ::= 1                     // 1 = quarter note
  register ::= 5                     // octave
  volume ::= 63                      // volume (0-127)
  tempo ::= 120                      // tempo in BPM
  instrument ::= nil                 // instrument
  deltadegree ::= :same              // did the pitch raise or lower?
  
  clone := method(self)      // singleton
  
  init := method(
    self scale = silica scale("C-MAJOR")
    self degree = 1
    self duration = 1
    self register = 5
    self volume = 63
    self tempo = 120
    //self instrument = silica instrument("PIANO")
    self deltadegree = :same
  )
  
  reset := method(self init; self)
  
  rp := method(
    new := self degree + 1
    if(new == self scale size + 1, new = 1; self setRegister(self register + 1))
    self setDegree(new)
    self setDeltadegree(:raise)
  )
  
  lp := method(
    new := self degree - 1
    if(new == 0, new = self scale size; self setRegister(self register - 1))
    self setDegree(new)
    self setDeltadegree(:lower)
  )
  
  play := method(
    out := ""
    if(self deltadegree == :lower, out = out .. "\\ ")
    if(self deltadegree == :raise, out = out .. "/ ")
    self setDeltadegree(:same)
    out = out .. self scale getNameForDegree(self degree) .. self duration
    out
  )
  
  rest := method(
    "S:" .. self duration
  )
  
  expand := method(factor,
    self setDuration(self duration * factor)
  )
  
  shrink := method(factor,
    self setDuration(self duration / factor)
  )
  
  x2 := method(self expand(2))
  x3 := method(self expand(3))
  x5 := method(self expand(5))
  x7 := method(self expand(7))
  
  s2 := method(self shrink(2))
  s3 := method(self shrink(3))
  s5 := method(self shrink(5))
  s7 := method(self shrink(7))
  
  
  asString := method(
    out := "NOTE < \n" .. "  scale = " .. self scale
    out = out .. "\n  degree = " .. self degree
    out = out .. "\n  register = " .. self register
    out = out .. "\n  duration = " .. self duration
    out = out .. "\n  deltadegree = " .. self deltadegree
    out = out .. "\n>"
  )
)
