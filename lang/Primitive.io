// silica programming language
// Jacob M. Peck
// Primitive proto

if(?REPL_DEBUG, writeln("  + Loading Primitive.io"))

/*
 * Class: Primitive
 *   Extends <Entity>
 *
 * The internal representation of a silica Primitive
 */
silica Primitive := silica Entity clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * behavior - the behavior of the primitive, as an Io block
   */
  behavior ::= nil
  
  init := method(
    self name = nil
    self behavior = nil
  )
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Constructor
  /*
   * Method: with(name, description, behavior)
   * 
   * Constructs a new Primitive with the parameters provided
   * 
   * Parameters:
   *   name - the name of the primitive
   *   description - a textual description of the primitive's behavior
   *   behavior - the behavior of the primitive, as an Io block
   * 
   * Returns:
   *   Primitive
   */
  with := method(name, description, behavior,
    self clone setName(name) setDescription(description) setBehavior(behavior)
  )
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Expansion
  /*
   * Method: execute
   * 
   * Executes the behavior of the primitive
   * 
   * Parameters:
   *   none
   * 
   * Returns:
   *   varies
   */
  execute := method(
    out := self behavior call
    out
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: asString
   *
   * Returns a string representation of the Primitive
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< PRIMITIVE " .. self name .. " >"
  )
)
