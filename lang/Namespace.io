// silica programming language
// Jacob M. Peck
// Namespace proto

if(?REPL_DEBUG, writeln("  + Loading Namespace.io"))

/*
 * Class: Namespace
 *
 * The internal representation of a silica Namespace
 */
silica Namespace := Object clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * name - the namespace name
   * parent - the namespace's parent
   * children - a list of the namespace's children
   */
  name ::= nil
  parent ::= nil
  children ::= nil
  
  init := method(
    self name = nil
    self parent = nil
    self children = list
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Constructor
  /*
   * Method: with(name, parent)
   * 
   * Constructs a new Namespace with the parameters provided
   * 
   * Parameters:
   *   name - the name of the namespace
   *   parent -the parent namespace
   * 
   * Returns:
   *   Namespace
   */
  with := method(name, parent,
    self clone setName(name) setParent(parent)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Mitators
  /*
   * Method: addChild(child)
   * 
   * Adds a child to the namespace's children list
   * 
   * Parameters:
   *   child - the child namespace
   * 
   * Returns:
   *   self
   */
  addChild := method(child,
    self children append(child)
    self
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: asString
   *
   * Returns a string representation of the Namespace
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< NAMESPACE " .. self constructName asMutable uppercase .. " >"
  )
  
  /*
   * Method: constructName
   *
   * Constructs the fully qualified name of the namespace
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  constructName := method(
    if(self parent != nil,
      self parent constructName .. "::" .. self name
      ,
      self name
    )
  )
)


/*
 * Class: NamespaceTable
 *   Extends <EntityTable>
 *
 * The table which holds all of the <Namespace> objects
 */
silica NamespaceTable := silica EntityTable clone do(
  clone := method(self)
  
  /*
   * Method: new(name, parent)
   *
   * Adds a new namespace defined by the parameters
   *
   * Parameters:
   *   name - the new namespace's name
   *   parent - the new namespace's parent
   *
   * Returns:
   *   namespace
   */
  new := method(name, parent,
    if(parent != nil,
      self table atIfAbsentPut(parent constructName .. "::" .. name, silica Namespace with(name, parent))
      ,
      self table atIfAbsentPut(name, silica Namespace with(name, parent))
    )
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the NamespaceTable
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< NAMESPACETABLE >"
  )
)

if(?REPL_DEBUG, writeln("    + Creating namespace HOME..."))
silica NamespaceTable new("home", nil)