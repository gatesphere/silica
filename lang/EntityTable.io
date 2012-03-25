// silica programming language
// Jacob M. Peck
// EntityTable proto

if(?REPL_DEBUG, writeln("  + Loading EntityTable.io"))

/*
 * Class: EntityTable
 *
 * Base class for a table that stores an entity by name
 */
silica EntityTable := Object clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * table - a map which stores entities
   */
  table := Map clone
  
  init := method(
    self table = Map clone
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Accessors
  /* Method: get(name)
   *
   * Gets the entity mapped to by name
   *
   * Parameters:
   *   name - key into table
   *
   * Returns:
   *   entity
   */
  get := method(name,
    self table at(name)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /* Method: asString
   *
   * Returns a string representation of the entity table
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< ENTITYTABLE >"
  )
)