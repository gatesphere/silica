// silica programming language
// Jacob M. Peck
// InstrumentChanger proto

if(?REPL_DEBUG, writeln("  + Loading InstrumentChanger.io"))

/*
 * Class: InstrumentChanger
 *   Extends <Primitive>
 *
 * The internal representation of a silica Instrument Change primitive
 */
silica InstrumentChanger := silica Primitive clone do(
   
  /*
   * Method: asString
   *
   * Returns a string representation of the InstrumentChanger
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */   
   asString := method(
    "< INSTRUMENTCHANGER " .. self name .. " >"
  )
)