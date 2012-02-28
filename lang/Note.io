// silica programming language
// Jacob M. Peck
// Note proto

if(?REPL_DEBUG, writeln("  + Loading Note.io"))

silica Note := Object clone do(
  scale ::= nil                      // C-Major scale
  degree ::= 1                       // scale degree
  duration ::= 1                     // 1 = quarter note
  register ::= 5                     // octave
  volume ::= 63                      // volume (0-127)
  tempo ::= 120                      // tempo in BPM
  instrument ::= nil                 // instrument
  deltadegree ::= :same              // did the pitch raise or lower?
  statestack ::= nil
  
  clone := method(self)      // singleton
  
  init := method(
    self scale = list(silica scale("C-MAJOR"))
    self degree = 1
    self duration = 1
    self register = 5
    self volume = 63
    self tempo = 120
    //self instrument = silica instrument("PIANO")
    self deltadegree = :same
    self statestack = list
  )
  
  reset := method(self init; self)
  
  rp := method(
    new := self degree + 1
    if(new == self scale last size + 1, new = 1; self setRegister(self register + 1))
    self setDegree(new)
    self setDeltadegree(:raise)
    nil
  )
  
  lp := method(
    new := self degree - 1
    if(new == 0, new = self scale last size; self setRegister(self register - 1))
    self setDegree(new)
    self setDeltadegree(:lower)
    nil
  )
  
  cp := method(
    if(Random value > 0.5, self lp, self rp)
    nil
  )
  
  play := method(
    out := ""
    if(self deltadegree == :lower, out = out .. "\\ ")
    if(self deltadegree == :raise, out = out .. "/ ")
    self setDeltadegree(:same)
    out = out .. self scale last getNameForDegree(self degree) .. self duration
    out
  )
  
  rest := method(
    "S" .. self duration
  )
  
  mute := method(
    "M" .. self duration
  )
  
  expand := method(factor,
    self setDuration(self duration * factor)
    nil
  )
  
  shrink := method(factor,
    self setDuration(self duration / factor)
    nil
  )
  
  x2 := method(self expand(2))
  x3 := method(self expand(3))
  x5 := method(self expand(5))
  x7 := method(self expand(7))
  
  s2 := method(self shrink(2))
  s3 := method(self shrink(3))
  s5 := method(self shrink(5))
  s7 := method(self shrink(7))
  
  changeScale := method(new_scale,
    if(?REPL_DEBUG, writeln("TRACE: Changing to scale " .. new_scale name .. " (absolute mode)"))
    self setDegree(1)
    self scale push(new_scale)
    self setDeltadegree(:same)
    nil
  )
  
  changeScaleRelative := method(new_scale,
    if(?REPL_DEBUG, writeln("TRACE: Changing to scale " .. new_scale name .. " (relative mode)"))
    pitch := self scale last getNameForDegree(self degree)
    new_degree := new_scale getDegreeForName(pitch)
    if(new_degree == nil,
      writeln("--> Cannot change to scale " .. new_scale name .. " relatively: pitch " .. pitch .. " not in scale.")
      ,
      self setDegree(new_degree)
      self scale push(new_scale)
    )
    nil
  )
  
  popalphabet := method(
    if(?REPL_DEBUG, writeln("TRACE: Popping scale (absolute mode)."))
    if(self scale size == 1,
      writeln("--> Cannot pop alphabet: must leave one in stack.")
      ,
      self scale pop
      self setDegree(1)
      self setDeltadegree(:same)
    )
    nil
  )
  
  popalphabetRelative := method(
    if(?REPL_DEBUG, writeln("TRACE: Popping scale (relative mode)."))
    if(self scale size == 1,
      writeln("--> Cannot pop alphabet: must leave one in stack.")
      ,
      pitch := self scale last getNameForDegree(self degree)
      new_scale := self scale at(self scale size - 2)
      new_degree := new_scale getDegreeForName(pitch)
      if(new_degree == nil,
        writeln("--> Cannot pop to scale " .. new_scale name .. " relatively: pitch " .. pitch .. " not in scale.")
        ,
        self scale pop
        self setDegree(new_degree)
      )
    )
    nil
  )
  
  pushstate := method(
    state := list(
      self scale, 
      self degree, 
      self duration, 
      self register, 
      self volume, 
      self tempo, 
      self instrument, 
      self deltadegree
    )
    self statestack push(state)
    nil
  )
  
  popstate := method(
    if(self statestack size != 0,
      self applystate(self statestack pop)
    )
    nil
  )
  
  removestate := method(
    if(self statestack size != 0,
      self statestack pop
    )
    nil
  )
  
  applystate := method(state,
    n_scale := state at(0)
    n_degree := state at(1)
    n_duration := state at(2)
    n_register := state at(3)
    n_volume := state at(4)
    n_tempo := state at(5)
    n_instrument := state at(6)
    n_deltadegree := state at(7)
    
    self setScale(n_scale)
    self setDegree(n_degree)
    self setDuration(n_duration)
    self setRegister(n_register)
    self setVolume(n_volume)
    self setTempo(n_tempo)
    self setInstrument(n_instrument)
    self setDeltadegree(n_deltadegree)
    
    nil
  )
  
  asString := method(
    out := "NOTE < \n" .. "  scalestack = " .. self scale
    out = out .. "\n  degree = " .. self degree
    out = out .. "\n  register = " .. self register
    out = out .. "\n  duration = " .. self duration
    out = out .. "\n  deltadegree = " .. self deltadegree
    out = out .. "\n>"
  )
  
)
