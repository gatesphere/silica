// silica programming language
// Jacob M. Peck
// Macro proto

if(?REPL_DEBUG, writeln("  + Loading Macro.io"))

/*
 * Class: Macro
 *   Extends <Entity>
 *
 * The internal representation of a silica Macro
 */
silica Macro := silica Entity clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * value - the body of the Macro
   */
  value ::= nil
  
  init := method(
    self value = nil
    self name = nil
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Expansion
  /*
   * Method: expand
   * 
   * Returns the body of the macro
   * 
   * Parameters:
   *   none
   * 
   * Returns:
   *   string
   */
  expand := method(
    self value
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Constructor
  /*
   * Method: with(name, value)
   * 
   * Constructs a new Macro with the parameters provided
   * 
   * Parameters:
   *   name - the name of the macro
   *   value - the body of the macro
   * 
   * Returns:
   *   Macro
   */
  with := method(name, value,
    self clone setName(name) setValue(value)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: asString
   *
   * Returns a string representation of the Macro
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< MACRO " .. self name uppercase .. " >"
  )
)
