// silica programming language
// Jacob M. Peck
// Note proto

if(?REPL_DEBUG, writeln("  + Loading Note.io"))

silica Note := Object clone do(
  scale ::= nil                      // C-Major scale
  degree ::= 1                       // scale degree
  duration ::= 1                     // 1 = quarter note
  register ::= 5                     // octave
  prevregister ::= 5
  volume ::= 12000                   // volume (0-16000)
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
    self prevregister = 5
    self volume = 12000
    self tempo = 120
    self instrument = silica instrument("PIANO")
    self deltadegree = :same
    self statestack = list
  )
  
  reset := method(self init; list(self, nil))
  
  // pitch+register
  rp := method(
    new := self degree + 1
    if(new == self scale last size + 1, 
      new = 1 
      if(self register < 9, self setRegister(self register + 1))
    )
    self setDegree(new)
    self setDeltadegree(:raise)
    list(nil,nil)
  )
  
  lp := method(
    new := self degree - 1
    if(new == 0,
      new = self scale last size
      if(self register > 0, self setRegister(self register - 1))
    )
    self setDegree(new)
    self setDeltadegree(:lower)
    list(nil,nil)
  )
  
  cp := method(
    if(Random value > 0.5, self lp, self rp)
  )
  
  // play commands
  play := method(
    out := ""
    if(self deltadegree == :lower, out = out .. "\\")
    if(self deltadegree == :raise, out = out .. "/")
    deltaRegister := self prevregister - self register
    while(deltaRegister < -1,
      deltaRegister = deltaRegister + 1
      out = out .. "/"
    )
    while(deltaRegister > 1,
      deltaRegister = deltaRegister - 1
      out = out .. "\\"
    )
    self prevregister = self register
    self setDeltadegree(:same)
    pitch := self scale last getNameForDegree(self degree)
    out = out .. " " .. pitch .. self duration
    out2 := pitch .. self scale last getSirenOctave(register, pitch) .. "/" .. (self duration / 4.0)
    list(out,out2)
  )
  
  rest := method(
    list("S" .. self duration, "R/" .. (self duration / 4.0))
  )
  
  /*
  mute := method(
    "M" .. self duration
  )
  */
  
  // duration
  expand := method(factor,
    self setDuration(self duration * factor)
    list(nil,nil)
  )
  
  shrink := method(factor,
    self setDuration(self duration / factor)
    list(nil,nil)
  )
  
  x2 := method(self expand(2))
  x3 := method(self expand(3))
  x5 := method(self expand(5))
  x7 := method(self expand(7))
  
  s2 := method(self shrink(2))
  s3 := method(self shrink(3))
  s5 := method(self shrink(5))
  s7 := method(self shrink(7))
  
  // volume (amplitude)
  setVol := method(value,
    if(value < 0, value = 0)
    if(value > 16000, value = 16000)
    self setVolume(value)
    list(nil, "$" .. self volume)
  )
  
  setVolRelative := method(value,
    self setVol(self volume + value)
  )
  
  maxvol := method(self setVol(16000))
  minvol := method(self setVol(0))
  midvol := method(self setVol(8000))
  startvol := method(self setVol(12000))
  incvol := method(self setVolRelative(1000))
  incvol1 := method(self setVolRelative(100))
  decvol := method(self setVolRelative(-1000))
  decvol1 := method(self setVolRelative(-100))
  
  // tempo
  setTemp := method(value,
    if(value < 20, value = 20)
    if(value > 400, value = 400)
    self setTempo(value)
    list(nil, "!" .. self tempo)
  )
  
  setTempRelative := method(value,
    self setTemp(self tempo + value)
  )
  
  doubletempo := method(self setTemp(self tempo * 2))
  tripletempo := method(self setTemp(self tempo * 3))
  halftempo := method(self setTemp(self tempo / 2))
  thirdtempo := method(self setTemp(self tempo / 3))
  mintempo := method(self setTemp(20))
  maxtempo := method(self setTemp(400))
  midtempo := method(self setTemp(190))
  starttempo := method(self setTemp(120))
  inctempo := method(self setTempRelative(10))
  inctempo1 := method(self setTempRelative(1))
  dectempo := method(self setTempRelative(-10))
  dectempo1 := method(self setTempRelative(-1))
  
  // scale
  changeScale := method(new_scale,
    if(?REPL_DEBUG, writeln("TRACE: Changing to scale " .. new_scale name .. " (absolute mode)"))
    self setDegree(1)
    self scale push(new_scale)
    self setDeltadegree(:same)
    list(nil,nil)
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
    list(nil,nil)
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
    list(nil,nil)
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
    list(nil,nil)
  )
  
  // instrument
  changeInstrument := method(inst,
    self setInstrument(inst)
    list(nil, "@" .. self instrument name)
  )
  
  // state
  pushstate := method(
    state := list(
      self scale, 
      self degree, 
      self duration, 
      self register, 
      self volume, 
      self tempo, 
      self instrument, 
      self deltadegree,
      self prevregister
    )
    self statestack push(state)
    list(nil,nil)
  )
  
  popstate := method(
    if(self statestack size != 0,
      self applystate(self statestack pop)
    )
    list(nil,nil)
  )
  
  removestate := method(
    if(self statestack size != 0,
      self statestack pop
    )
    list(nil,nil)
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
    n_prevregister := state at(8)
    
    self setScale(n_scale)
    self setDegree(n_degree)
    self setDuration(n_duration)
    self setRegister(n_register)
    self setVolume(n_volume)
    self setTempo(n_tempo)
    self setInstrument(n_instrument)
    self setDeltadegree(n_deltadegree)
    self setPrevregister(n_prevregister)
    
    nil
  )
  
  // reporting
  asString := method(
    out := "NOTE < \n" .. "  scalestack = " .. self scale
    out = out .. "\n  degree = " .. self degree
    out = out .. "\n  register = " .. self register
    out = out .. "\n  duration = " .. self duration
    out = out .. "\n  deltadegree = " .. self deltadegree
    out = out .. "\n  volume = " .. self volume
    out = out .. "\n  tempo = " .. self tempo
    out = out .. "\n  instrument = " .. self instrument
    out = out .. "\n  prevregister = " .. self prevregister
    out = out .. "\n>"
  )
  
)
