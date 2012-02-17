// silica programming language
// Jacob M. Peck
// Function proto

if(?REPL_DEBUG, writeln("  + Loading Function.io"))

silica Function := silica Macro clone do(
  params ::= nil
  
  init := method(
    self params = nil
    self value = nil
    self name = nil
  )
  
  with := method(name, value, params,
    self clone setName(name) setValue(self expandValue(value)) setParams(params)
  )
  
  // repetition and grouping factors...expand them
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
  
  asString := method(
    "< FUNCTION " .. self name uppercase .. " >"
  )
)
