// Io symbolic atom library
// Jacob M. Peck

// todo:
// examples

//doFile("io-symbols-operator.io")

// magic
Object : := method(
  msg := call argAt(0)
  name := msg name
  if(msg next == nil,
    SymbolTable get(name),
    SymbolTable get(name) doMessage(msg next)
  )
)

// more magic
//OperatorTable addOperator(":", 1) // change priority?  1 seems to work for me...

// Symbol proto
Symbol := Object clone do(
  str ::= ""
  plist ::= list
  
  // ctor
  init := method(
    self str = ""
    self plist = list
  )
  
  // ctor
  with := method(string,
    Symbol clone setStr(string)
  )
  
  // printrep
  asString := method(
    ":" .. self str
  )
  
  // plist methods... glorified map as an even-length list
  // return the value associated with indicator
  get := method(indicator,
    pos := self plist indexOf(indicator)
    if(pos != nil,
      self plist at(self plist indexOf(indicator) + 1),
      nil
    )
  )
  
  // set the value of indicator
  set := method(indicator, value,
    pos := self plist indexOf(indicator)
    if(pos == nil,
      self plist append(indicator) append(value),
      self plist atPut(pos + 1, value)
    )
    self
  )
  
  // remove the indicator and it's value
  remove := method(indicator,
    pos := self plist indexOf(indicator)
    if(pos != nil,
      self plist removeAt(pos);
      self plist removeAt(pos);
    )
    self
  )
  
  // return the plist of this symbol
  symbol_plist := method(
    self plist
  )
)

// SymbolTable proto
SymbolTable := Object clone do(
  table := Map clone
  
  clone := method(self) // singleton
  
  get := method(name,
    self table atIfAbsentPut(name asString, Symbol with(name asString))
  )
)
