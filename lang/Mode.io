// silica programming language
// Jacob M. Peck
// Mode proto

if(?REPL_DEBUG, writeln("  + Loading Mode.io"))

/*
 * Class: Mode
 *   Extends <Entity>
 *
 * The internal representation of a silica Mode
 */
silica Mode := silica Entity clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * intervals - a list of intervalic steps which make up the mode
   */
  intervals ::= nil
  
  init := method(
    self intervals = nil
    self name = nil
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Constructor
  /*
   * Method: with(name, intervals)
   * 
   * Constructs a new Mode with the parameters provided
   * 
   * Parameters:
   *   name - the name of the mode
   *   intervals - the interval list of the mode
   * 
   * Returns:
   *   Mode
   */
  with := method(name, intervals,
    self clone setName(name) setIntervals(intervals)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: size
   * 
   * Returns the number of pitches involved in a scale of this mode
   * 
   * Parameters:
   *   none
   * 
   * Returns:
   *   number
   */
  size := method( self intervals size )
  

  /*
   * Method: asString
   *
   * Returns a string representation of the Mode
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< MODE " .. self name asMutable uppercase .. " >"
  )
)

/*
 * Class: ModeTable
 *   Extends <EntityTable>
 *
 * The table which holds all of the <Mode> objects
 */
silica ModeTable := silica EntityTable clone do(
  clone := method(self)
  
  /*
   * Method: new(name, intervals)
   *
   * Adds a new mode defined by the parameters
   *
   * Parameters:
   *   name - the new mode's name
   *   intervals - the new mode's interval list
   *
   * Returns:
   *   mode
   */
  new := method(name, intervals,
    self table atIfAbsentPut(name, silica Mode with(name, intervals))
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the ModeTable
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< MODETABLE >"
  )
)