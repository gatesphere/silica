// silica programming language
// Jacob M. Peck
// TokenTable proto

if(?REPL_DEBUG, writeln("  + Loading TokenTable.io"))

/*
 * Class: TokenTable
 *
 * The global lookup table for tokens
 */
silica TokenTable := Object clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * namespace_table - A map, which stores (string, map<string, token>) pairs
   */
  namespace_table := Map clone
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Initializers 
  /*
   * Method: clone
   *
   * Returns the TokenTable object (singleton)
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   The singleton TokenTable object
   */
  clone := method(self)

  //////////////////////////////////////////////////////////////////////////////
  // Group: Mutators
  /* Method: get(namespace, name)
   *
   * Gets the token mapped to by name within namespace
   *
   * Parameters:
   *   namespace - namespace in which to look
   *   name - key into table
   *
   * Returns:
   *   token
   */
  get := method(namespace, name,
    token_table := self namespace_table at(namespace constructName)
    if(token_table != nil,
      return token_table at(name),
      return nil
    )
  )
  
  /* Method: add(namespace, name, token)
   *
   * Adds the token to the table, mapped by namespace and name
   *
   * Parameters:
   *   namespace - namespace in which to map
   *   name - key into table
   *   token - the token to add
   *
   * Returns:
   *   self
   */
  add := method(namespace, name, token,
    token_table := self namespace_table atIfAbsentPut(namespace constructName, Map clone)
    token_table atPut(name, token)
    self
  )
  
  /* Method: remove(namespace, name)
   *
   * Removes the token mapped to by namespace and name
   *
   * Parameters:
   *   namespace - namespace in which to look
   *   name - key into table
   *
   * Returns:
   *   self
   */
  remove := method(namespace, name,
    token_table := self namespace_table atIfAbsentPut(namespace constructName, Map clone)
    token_table removeAt(name)
    self
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: asString
   *
   * Returns a string representation of the TokenTable
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< TOKENTABLE >"
  )
)
