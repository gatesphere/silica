// silica programming language
// Jacob M. Peck
// Scale proto

silica Scale := Object clone do(
  name ::= nil
  intervals ::= nil
  tonic ::= nil
  
  init := method(
    self name = nil
    self intervals = nil
    self tonic = nil
  )
  
  with := method(name, intervals,
    self clone setName(name) setIntervals(intervals)
  )
  
  size := method(self intervals size)
  //getNameForDegree := method(degree, self intervals at(degree - 1))
  
  asString := method(
    "SCALE< " .. self name .. " >"
  )
)

silica ScaleTable := Object clone do(
  table := Map clone
  
  clone := method(self)
  
  get := method(name,
    self table at(name)
  )
  
  new := method(name, intervals, tonic,
    self table atIfAbsentPut(name, silica Scale with(name, intervals, tonic))
  )
)

// initial scales
silica ScaleTable new("C-MAJOR", list(2,2,1,2,2,2,1), "C");
// ...