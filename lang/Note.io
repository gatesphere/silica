// silica programming language
// Jacob M. Peck
// Note proto

if(?REPL_DEBUG, writeln("  + Loading Note.io"))

/*
 * Class: Note
 *
 * The internal representation of the global Note object
 */
silica Note := Object clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * scale - The scale stack
   * degree - The scale degree
   * duration - The note's duration, where 1 = quarter note
   * register - The note's octave
   * prevregister - The note's previous register
   * volume - The note's MIDI volume
   * tempo - The note's tempo, in BPM
   * instrument - The note's instrument
   * deltadegree - Whether the note's degree went up (:raise), down (:lower), or not at all (:same)
   * statestack - A stack of states
   */
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
  

  //////////////////////////////////////////////////////////////////////////////
  // Group: Initializers 
  /*
   * Method: clone
   *
   * Returns the Note object (singleton)
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   The singleton Note object
   *
   * See Also:
   *   <init>
   */
  clone := method(self)      // singleton
  
  /*
   * Method: init
   *
   * Initializes the Note object to the default values
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   The singleton Note object
   *
   * See Also:
   *   <clone>
   */
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
  
  /*
   * Method: reset
   *
   * Calls init, and returns self
   */
  reset := method(self init; self)
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Pitch Mutators
  /*
   * Method: rp
   *
   * Raises the pitch by one degree, respecting octave boundaries
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <lp>, <cp>
   */
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
  
  /*
   * Method: lp
   *
   * Lowers the pitch by one degree, respecting octave boundaries
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <rp>, <cp>
   */
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
  
  /*
   * Method: cp
   *
   * Non-deterministically calls either lp or rp
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <rp>, <cp>
   */
  cp := method(
    if(Random value > 0.5, self lp, self rp)
  )
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Play Commands
  /*
   * Method: play
   *
   * Plays the note with the current properties
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(textual_output, siren_output)
   *
   * See Also:
   *   <rest>
   */
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
  
  /*
   * Method: rest
   *
   * Rests the note with the current properties
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(textual_output, siren_output)
   *
   * See Also:
   *   <play>
   */
  rest := method(
    list("S" .. self duration, "R/" .. (self duration / 4.0))
  )
  
  /*
  mute := method(
    "M" .. self duration
  )
  */
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Duration Mutators
  /*
   * Method: expand(factor)
   *
   * Expands the duration by a factor
   *
   * Parameters:
   *   factor - the factor to expand the duration by
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <shrink(factor)>, <x2>, <x3>, <x5>, <x7>
   */
  expand := method(factor,
    self setDuration(self duration * factor)
    list(nil,nil)
  )
  
  /*
   * Method: shrink(factor)
   *
   * Shrinks the duration by a factor
   *
   * Parameters:
   *   factor - the factor to expand the duration by
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <expand(factor)>, <s2>, <s3>, <s5>, <s7>
   */
  shrink := method(factor,
    self setDuration(self duration / factor)
    list(nil,nil)
  )
  
  /*
   * Method: x2
   *
   * Calls expand(2)
   */
  x2 := method(self expand(2))
  /*
   * Method: x3
   *
   * Calls expand(3)
   */
  x3 := method(self expand(3))
  /*
   * Method: x5
   *
   * Calls expand(5)
   */
  x5 := method(self expand(5))
  /*
   * Method: x7
   *
   * Calls expand(7)
   */
  x7 := method(self expand(7))
  
  /*
   * Method: s2
   *
   * Calls shrink(2)
   */
  s2 := method(self shrink(2))
  /*
   * Method: s3
   *
   * Calls shrink(3)
   */
  s3 := method(self shrink(3))
  /*
   * Method: s5
   *
   * Calls shrink(5)
   */
  s5 := method(self shrink(5))
  /*
   * Method: s7
   *
   * Calls shrink(7)
   */
  s7 := method(self shrink(7))
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Volume Mutators
  /*
   * Method: setVol(value)
   *
   * Sets the volume to value
   *
   * Parameters:
   *   value - the value to set the volume to
   *
   * Returns:
   *   list(nil, siren_output)
   *
   * See Also:
   *   <setVolRelative(value)>, <maxvol>, <minvol>, <midvol>, <startvol>
   */
  setVol := method(value,
    if(value < 0, value = 0)
    if(value > 16000, value = 16000)
    self setVolume(value)
    list(nil, "$" .. self volume)
  )
  
  /*
   * Method: setVolRelative(value)
   *
   * Sets the volume to (current volume + value)
   *
   * Parameters:
   *   value - the delta value to modify the volume by
   *
   * Returns:
   *   list(nil, siren_output)
   *
   * See Also:
   *   <setVol(value)>, <incvol>, <incvol1>, <decvol>, <decvol1>
   */
  setVolRelative := method(value,
    self setVol(self volume + value)
  )
  
  /*
   * Method: maxvol
   *
   * Calls setVol(16000)
   */
  maxvol := method(self setVol(16000))
  /*
   * Method: minvol
   *
   * Calls setVol(0)
   */
  minvol := method(self setVol(0))
  /*
   * Method: midvol
   *
   * Calls setVol(8000)
   */
  midvol := method(self setVol(8000))
  /*
   * Method: startvol
   *
   * Calls setVol(12000)
   */
  startvol := method(self setVol(12000))
  /*
   * Method: incvol
   *
   * Calls setVolRelative(1000)
   */
  incvol := method(self setVolRelative(1000))
  /*
   * Method: incvol1
   *
   * Calls setVolRelative(100)
   */
  incvol1 := method(self setVolRelative(100))
  /*
   * Method: decvol
   *
   * Calls setVolRelative(-1000)
   */
  decvol := method(self setVolRelative(-1000))
  /*
   * Method: decvol1
   *
   * Calls setVolRelative(-100)
   */
  decvol1 := method(self setVolRelative(-100))
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Tempo Mutators
  /*
   * Method: setTemp(value)
   *
   * Sets the tempo to value
   *
   * Parameters:
   *   value - the value to set the tempo to
   *
   * Returns:
   *   list(nil, siren_output)
   *
   * See Also:
   *   <setTempRelative(value)>, <doubletempo>, <tripletempo>, <halftempo>, <thirdtempo>, <mintempo>, <maxtempo>, <midtempo>, <starttempo>
   */
  setTemp := method(value,
    if(value < 20, value = 20)
    if(value > 400, value = 400)
    self setTempo(value)
    list(nil, "!" .. self tempo)
  )
  
  /*
   * Method: setTempRelative(value)
   *
   * Sets the tempo to (current tempo + value)
   *
   * Parameters:
   *   value - the delta value to modify the tempo by
   *
   * Returns:
   *   list(nil, siren_output)
   *
   * See Also:
   *   <setTemp(value)>, <inctempo>, <inctempo1>, <dectempo>, <dectempo1>, <mintempo>, <maxtempo>, <midtempo>, <starttempo>
   */
  setTempRelative := method(value,
    self setTemp(self tempo + value)
  )
  
  /*
   * Method: doubletempo
   *
   * Calls setTemp(self tempo * 2)
   */
  doubletempo := method(self setTemp(self tempo * 2))
  /*
   * Method: tripletempo
   *
   * Calls setTemp(self tempo * 3)
   */
  tripletempo := method(self setTemp(self tempo * 3))
  /*
   * Method: halftempo
   *
   * Calls setTemp(self tempo / 2)
   */
  halftempo := method(self setTemp(self tempo / 2))
  /*
   * Method: thirdtempo
   *
   * Calls setTemp(self tempo / 3)
   */
  thirdtempo := method(self setTemp(self tempo / 3))
  /*
   * Method: mintempo
   *
   * Calls setTemp(20)
   */
  mintempo := method(self setTemp(20))
  /*
   * Method: maxtempo
   *
   * Calls setTemp(400)
   */
  maxtempo := method(self setTemp(400))
  /*
   * Method: midtempo
   *
   * Calls setTemp(190)
   */
  midtempo := method(self setTemp(190))
  /*
   * Method: starttempo
   *
   * Calls setTemp(120)
   */
  starttempo := method(self setTemp(120))
  /*
   * Method: inctempo
   *
   * Calls setTempRelative(10)
   */
  inctempo := method(self setTempRelative(10))
  /*
   * Method: inctempo1
   *
   * Calls setTempRelative(1)
   */
  inctempo1 := method(self setTempRelative(1))
  /*
   * Method: dectempo
   *
   * Calls setTempRelative(-10)
   */
  dectempo := method(self setTempRelative(-10))
  /*
   * Method: dectempo1
   *
   * Calls setTempRelative(-1)
   */
  dectempo1 := method(self setTempRelative(-1))
  
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Scale Mutators
  /*
   * Method: changeScale(new_scale)
   *
   * Pushes new_scale on to the scale stack without respect to the current scale
   *
   * Parameters:
   *   new_scale - the new scale to push
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <changeScaleRelative(new_scale)>, <popalphabet>, <popalphabetRelative>
   */
  changeScale := method(new_scale,
    if(?REPL_DEBUG, writeln("TRACE: Changing to scale " .. new_scale name .. " (absolute mode)"))
    self setDegree(1)
    self scale push(new_scale)
    self setDeltadegree(:same)
    list(nil,nil)
  )
  
  /*
   * Method: changeScaleRelative(new_scale)
   *
   * Pushes new_scale on to the scale stack, only if the tonic of new_scale is in the current scale
   *
   * Parameters:
   *   new_scale - the new scale to push
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <changeScale(new_scale)>, <popalphabet>, <popalphabetRelative>
   */
  changeScaleRelative := method(new_scale,
    if(?REPL_DEBUG, writeln("TRACE: Changing to scale " .. new_scale name .. " (relative mode)"))
    pitch := self scale last getNameForDegree(self degree)
    new_degree := new_scale getDegreeForName(pitch)
    if(new_degree == nil,
      if(silica REPL REPL silent not,
        writeln("--> Cannot change to scale " .. new_scale name .. " relatively: pitch " .. pitch .. " not in scale.")
      )
      ,
      self setDegree(new_degree)
      self scale push(new_scale)
    )
    list(nil,nil)
  )

  /*
   * Method: popalphabet
   *
   * Pops the current scale from the scalestack, unless there's only one scale on the stack
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <changeScale(new_scale)>, <changeScaleRelative(new_scale)>, <popalphabetRelative>
   */
  popalphabet := method(
    if(?REPL_DEBUG, writeln("TRACE: Popping scale (absolute mode)."))
    if(self scale size == 1,
      if(silica REPL REPL silent,
        writeln("--> Cannot pop alphabet: must leave one in stack.")
      )
      ,
      self scale pop
      self setDegree(1)
      self setDeltadegree(:same)
    )
    list(nil,nil)
  )
  
  /*
   * Method: popalphabetRelative
   *
   * Pops the current scale from the scalestack, unless there's only one scale on the stack or the current pitch is not in the scale under it
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <changeScale(new_scale)>, <changeScaleRelative(new_scale)>, <popalphabet>
   */
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
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Intrument Mutators
  /*
   * Method: changeInstrument(inst)
   *
   * Pops the current scale from the scalestack, unless there's only one scale on the stack
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, siren_output)
   */
  changeInstrument := method(inst,
    self setInstrument(inst)
    list(nil, "@" .. self instrument name)
  )
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: State Mutators
  /*
   * Method: pushstate
   *
   * Pushes the current state onto the state stack
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <popstate>, <removestate>, <applystate(state)>
   */
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
  
  /*
   * Method: popstate
   *
   * Pops a state off of the state stack and applies it to the Note
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <pushstate>, <removestate>, <applystate(state)>
   */
  popstate := method(
    if(self statestack size != 0,
      self applystate(self statestack pop)
    )
    list(nil,nil)
  )
  
  /*
   * Method: removestate
   *
   * Pops the top state off of the state stack without applying it to the Note
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <pushstate>, <pushstate>, <applystate(state)>
   */
  removestate := method(
    if(self statestack size != 0,
      self statestack pop
    )
    list(nil,nil)
  )
  
  /*
   * Method: applystate(state)
   *
   * Applies state to the Note
   *
   * Parameters:
   *   state - the state to apply to the Note
   *
   * Returns:
   *   list(nil, nil)
   *
   * See Also:
   *   <pushstate>, <popstate>, <removestate>
   */
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
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: asString
   *
   * Returns a string representation of the Note
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
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
