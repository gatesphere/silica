// Jacob M. Peck
// Transform proto

if(?REPL_DEBUG, writeln("  + Loading Transform.io"))

/*
 * Class: Transform
 *   Extends <Entity>
 *
 * The internal representation of a silica Transform
 */
silica Transform := silica Entity clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * behavior - the transform's behavior, as an Io block
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
   * Constructs a new Transform with the parameters provided
   * 
   * Parameters:
   *   name - the name of the transform
   *   description - a textual description of the transform's behavior
   *   behavior - the behavior of the transform, as an Io block
   * 
   * Returns:
   *   Transform
   */
  with := method(name, description, behavior,
    self clone setName(name) setDescription(description) setBehavior(behavior)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Expansion
  /*
   * Method: execute(instring, scale)
   * 
   * Executes the behavior of the transform, prividing the parameters
   * 
   * Parameters:
   *   instring - the string of primitives on which to work
   *   scale - the current scale of the <Note>
   * 
   * Returns:
   *   string
   */
  execute := method(instring, scale,
    self behavior call(instring, scale)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /* Method: asString
   *
   * Returns a string representation of the transform
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< TRANSFORM " .. self name asMutable uppercase .. " >"
  )
)
