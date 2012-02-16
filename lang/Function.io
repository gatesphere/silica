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
    self clone setName(name) setValue(value) setParams(params)
  )
  
  expand := method(inargs,
    val := self value split
    new := list
    self params foreach(i, paramname,
      val foreach(argname,
        if(argname == paramname,
          new append(inargs at(i)),
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
