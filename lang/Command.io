// silica programming language
// Jacob M. Peck
// Command proto

if(?REPL_DEBUG, writeln("  + Loading Command.io"))

/*
 * Class: Command
 *   Extends <silica Macro>
 *
 * The internal representation of a silica Command
 */
silica Command := silica Macro clone do(
  /*
   * Method: expand
   *
   * Returns the value as a string, surrounded by curly braces
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  expand := method(
    "{ " .. self value .. " }"
  )
  
  /*
   * Method: asString
   *
   * Returns a string representation of the Command
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< COMMAND " .. self name uppercase .. " >"
  )
)