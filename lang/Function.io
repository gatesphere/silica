// silica programming language
// Jacob M. Peck
// Function proto

if(?REPL_DEBUG, writeln("  + Loading Function.io"))

/*
 * Class: Function
 *   Extends <Macro>
 *
 * The internal representation of a silica Function
 */
silica Function := silica Macro clone do(
  //////////////////////////////////////////////////////////////////////////////
  // Group: Fields
  /* Topic: Object fields
   *
   * Note:
   *   Unless otherwise noted, all fields include a setSlot(value) method
   *
   * params - a list of the parameters as string tokens
   */
  params ::= nil
  
  init := method(
    self params = nil
    self value = nil
    self name = nil
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Constructor
  /*
   * Method: with(name, value, params)
   *
   * Constructs a new Function with the parameters provided
   *
   * Parameters:
   *   name - the function's name
   *   value - the function's body
   *   params - the function's params
   *
   * Returns:
   *   Function
   */
  with := method(name, value, params,
    self clone setName(name) setValue(self expandValue(value)) setParams(params)
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Expansion
  /*
   * Method: expandValue(in)
   *
   * Expands all repetition and grouping factors in an input string
   *
   * Parameters:
   *   in - the string to expand
   *
   * Returns:
   *   string
   */
  expandValue := method(in,
    out := list
    changed := true
    while(changed,
      changed = false
      in splitNoEmpties foreach(tok,
        if(tok asNumber isNan, // not a repetition factor
          if(tok containsSeq("+"), // grouping factor
            changed = true
            out append(tok beforeSeq("+"))
            out append(tok afterSeq("+"))
            ,
            // neither grouping or repetition
            out append(tok)
          )
          ,
          // repetition factor
          changed = true
          num := tok asNumber
          info := tok afterSeq(num asString)
          num repeat(
            out append(info)
          )
        )
      )
      in = out join(" ")
      out = list
      if(?REPL_DEBUG, writeln("TRACE (expandValue) step: " .. in))
    )
    if(?REPL_DEBUG, writeln("TRACE (expandValue) returning: " .. in))
    in
  )
  
  /*
   * Method: expand(in)
   *
   * Expands the body, replacing all valid parameters with their replacement tokens
   *
   * Parameters:
   *   in - the parameter expansion list
   *
   * Returns:
   *   string
   */
  expand := method(in,
    inargs := list
    if(in != nil, inargs = in splitNoEmpties(","), return self value)
    in = list
    curr := ""
    parencount := 0
    inargs foreach(i,
      if(i containsSeq("("),
        parencount = parencount + 1
      )
      if(parencount != 0,
        if(curr != "",
          curr = curr .. ","
        )
        curr = curr .. i
      )
      if(i containsSeq(")"),
        parencount = parencount - 1
      )
      if(parencount == 0,
        if(curr != "",
          in append(curr)
          curr = ""
          ,
          in append(i)
        )
      )
    )
    val := self value split
    new := list
    self params foreach(i, paramname,
      val foreach(argname,
        if(argname == paramname and in at(i) != nil,
          new append(in at(i)),
          new append(argname)
        )
      )
      val = new;
      new = list
    )
    val join (" ")
  )
  
  //////////////////////////////////////////////////////////////////////////////
  // Group: Reporting
  /*
   * Method: asString
   *
   * Returns a string representation of the Function
   *
   * Parameters:
   *   none
   *
   * Returns:
   *   string
   */
  asString := method(
    "< FUNCTION " .. self name uppercase .. " >"
  )
)
