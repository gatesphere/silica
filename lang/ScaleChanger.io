// silica programming language
// Jacob M. Peck
// ScaleChanger proto

if(?REPL_DEBUG, writeln("  + Loading ScaleChanger.io"))

/*
 * Class: ScaleChanger
 *   Extends <Primitive>
 *
 * The internal representation of a silica Scale Change primitive
 */
silica ScaleChanger := silica Primitive clone do(
  
  /*
   * Method: asString
   *
   * Returns a string representation of the ScaleChanger
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< SCALECHANGER " .. self name .. " >"
  )
)