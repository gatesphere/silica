// silica programming language
// Jacob M. Peck
// Instrument proto

if(?REPL_DEBUG, writeln("  + Loading Instrument.io"))

/*
 * Class: Instrument
 *   Extends <Entity>
 *
 * The internal representation of a silica Instrument
 */
silica Instrument := silica Entity clone do(
  /*
   * Method: with(name)
   *
   * Constructs a new Instrument with the name provided
   *
   * Parameters:
   *   name - the instrument's name
   *
   * Returns:
   *   Instrument
   */
  with := method(name,
    self clone setName(name)
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the Instrument
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< INSTRUMENT " .. self name .. " >"
  )
)

/*
 * Class: InstrumentTable
 *   Extends <EntityTable>
 *
 * The table which holds all of the <Instrument> objects
 */
silica InstrumentTable := silica EntityTable clone do(
  clone := method(self)
  
  /*
   * Method: new(name)
   *
   * Adds a new instrument named by the parameter
   *
   * Parameters:
   *   name - the new instrument's name
   *
   * Returns:
   *   instrument
   */
  new := method(name,
    self table atIfAbsentPut(name, silica Instrument with(name))
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the InstrumentTable
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< INSTRUMENTTABLE >"
  )
)
