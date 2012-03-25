// silica programming language
// Jacob M. Peck
// MetaCommand proto

if(?REPL_DEBUG, writeln("  + Loading MetaCommand.io"))

/*
 * Class: MetaCommand
 *   Extends <Primitive>
 *
 * The internal representation of a silica MetaCommand
 */
silica MetaCommand := silica Primitive clone do(
  /*
   * Method: execute(params)
   * 
   * Executes the behavior of the MetaCommand, passing it the parameter list.
   * 
   * Parameters:
   *   params - the parameter list
   * 
   * Returns:
   *   varies
   */
  execute := method(params,
    out := self behavior call(params)
    out
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the MetaCommand
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< METACOMMAND " .. self name .. " >"
  )
)
