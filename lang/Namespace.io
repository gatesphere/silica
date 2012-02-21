// silica programming language
// Jacob M. Peck
// Namespace proto

if(?REPL_DEBUG, writeln("  + Loading Namespace.io"))

silica Namespace := Object clone do(
  name ::= nil
  parent ::= nil
  children ::= nil
  
  init := method(
    self name = nil
    self parent = nil
    self children = list
  )
  
  addChild := method(child,
    self children append(child)
    self
  )
  
  with := method(name, parent,
    self clone setName(name) setParent(parent)
  )
  
  asString := method(
    "< NAMESPACE " .. self constructName asMutable uppercase .. " >"
  )
  
  constructName := method(
    if(self parent != nil,
      self parent constructName .. "::" .. self name
      ,
      self name
    )
  )
)

silica NamespaceTable := silica EntityTable clone do(
  clone := method(self)
  new := method(name, parent,
    if(parent != nil,
      self table atIfAbsentPut(parent constructName .. "::" .. name, silica Namespace with(name, parent))
      ,
      self table atIfAbsentPut(name, silica Namespace with(name, parent))
    )
  )
)

if(?REPL_DEBUG, writeln("    + Creating namespace HOME..."))
silica NamespaceTable new("home", nil)