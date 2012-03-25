// silica programming language
// Jacob M. Peck
// Entity proto

if(?REPL_DEBUG, writeln("  + Loading Entity.io"))

/*
 * Class: Entity
 *
 * The base class for objects with a name and description
 */
silica Entity := Object clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * name - the name of the entity
   * description - the description of the entity
   */
  name ::= nil
  description ::= nil
)
