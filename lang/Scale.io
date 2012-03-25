// silica programming language
// Jacob M. Peck
// Scale proto

if(?REPL_DEBUG, writeln("  + Loading Scale.io"))


/*
 * Class: Scale
 *   Extends <Entity>
 *
 * The internal representation of a silica Scale
 */
silica Scale := silica Entity clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * mode - the scale's mode
   * tonic - the scale's tonic
   * pitchnames - a list of the pitches contained within the scale
   */
  mode ::= nil
  tonic ::= nil
  pitchnames ::= nil
  
  init := method(
    self name = nil
    self mode = nil
    self tonic = nil
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Constructor and Initializers
  /*
   * Method: with(name, mode, tonic)
   * 
   * Constructs a new Scale with the parameters provided
   * 
   * Parameters:
   *   name - the name of the scale
   *   mode - the mode of the scale
   *   tonic - the tonic of the scale
   * 
   * Returns:
   *   Scale
   */
  with := method(name, mode, tonic,
    self clone setName(name) setMode(mode) setTonic(tonic) generatePitchnames
  )

  /*
   * Method: generatePitchnames
   * 
   * Generates the pitchnames list
   * 
   * Parameters:
   *   none
   * 
   * Returns:
   *   Scale
   */
  generatePitchnames := method(
    pn := list(tonic)
    pos := silica PitchNames indexOf(self tonic)
    last := self mode intervals clone
    last pop
    last foreach(i,
      pos = pos + i
      if (pos > silica PitchNames size - 1, pos = pos - (silica PitchNames size))
      pn append(silica PitchNames at(pos))
    )
    self setPitchnames(pn)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: size
   * 
   * Returns the number of pitches per octave
   * 
   * Parameters:
   *   none
   * 
   * Returns:
   *   number
   */
  size := method(self mode size)
  
  /*
   * Method: getNameForDegree(degree)
   * 
   * Returns pitchname for the given degree
   * 
   * Parameters:
   *   degree - the degree to look up
   * 
   * Returns:
   *   string
   * 
   * See Also:
   *   <getDegreeForName(name)>, <getOffsetFromC>, <getSirenOctave(orig, pitch)>
   */
  getNameForDegree := method(degree, self pitchnames at(degree - 1))
  
  /*
   * Method: getDegreeForName(name)
   * 
   * Returns scale degree for the given pitchname
   * 
   * Parameters:
   *   name - the pitchname to look up
   * 
   * Returns:
   *   number
   * 
   * See Also:
   *   <getNameForDegree(degree)>, <getOffsetFromC>, <getSirenOctave(orig, pitch)>
   */
  getDegreeForName := method(name, pos := self pitchnames indexOf(name); if(pos != nil, pos = pos + 1); pos)
  
  /*
   * Method: getOffsetFromC
   * 
   * Returns the offset from C that the tonic is
   * 
   * Parameters:
   *   none
   * 
   * Returns:
   *   number
   * 
   * See Also:
   *   <getDegreeForName(name)>, <getNameForDegree(degree)>, <getSirenOctave(orig, pitch)>
   */
  getOffsetFromC := method(
    pos := silica PitchNames indexOf(self tonic)
    if(pos > silica PitchNames size / 2,
      pos = pos - silica PitchNames size
    )
    //writeln(pos)
    pos
  )
  
  /*
   * Method: getSirenOctave(orig, pitch)
   * 
   * Returns the correct MIDI octave to send to Siren
   * 
   * Parameters:
   *   orig - the silica octave
   *   pitch - the pitchname
   * 
   * Returns:
   *   number
   * 
   * See Also:
   *   <getDegreeForName(name)>, <getNameForDegree(degree)>, <getOffsetFromC>
   */
  getSirenOctave := method(orig, pitch,
    offset := self getOffsetFromC
    lower := silica PitchNames exSlice(0, offset)
    higher := silica PitchNames exSlice(offset)
    //writeln(higher)
    //writeln(lower)
    //writeln(offset)
    if(offset < 0 and higher contains(pitch),
      //writeln(orig - 1)
      return orig - 1
      ,
      if(offset > 0 and lower contains(pitch),
        //writeln(orig + 1)
        return orig + 1
        ,
        //writeln(orig)
        return orig
      )
    )
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the Scale
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< SCALE " .. self name asMutable uppercase .. " >"
  )
)


/*
 * Class: ScaleTable
 *   Extends <EntityTable>
 *
 * The table which holds all of the <Scale> objects
 */
silica ScaleTable := silica EntityTable clone do(
  clone := method(self)
  
  /*
   * Method: new(name, mode, tonic)
   *
   * Adds a new scale defined by the parameters
   *
   * Parameters:
   *   name - the new scale's name
   *   mode - the new scale's mode
   *   tonic - the new scale's tonic
   *
   * Returns:
   *   scale
   */
  new := method(name, mode, tonic,
    self table atIfAbsentPut(name, silica Scale with(name, mode, tonic))
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the ScaleTable
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< SCALETABLE >"
  )
)

silica PitchNames := list("C","V","D","W","E","F","X","G","Y","A","Z","B")