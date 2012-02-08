// silica programming language
// Jacob M. Peck
// Scale proto

silica Scale := Object clone do(
  name ::= nil
  intervals ::= nil
  tonic ::= nil
  pitchnames ::= nil
  
  init := method(
    self name = nil
    self intervals = nil
    self tonic = nil
  )
  
  with := method(name, intervals, tonic,
    self clone setName(name) setIntervals(intervals) setTonic(tonic) generatePitchnames
  )
  
  generatePitchnames := method(
    pn := list(tonic)
    pos := silica PitchNames indexOf(self tonic)
    last := self intervals pop
    self intervals foreach(i,
      pos = pos + i
      if (pos > silica PitchNames size - 1, pos = pos - (silica PitchNames size))
      pn append(silica PitchNames at(pos))
    )
    self intervals append(last)
    self setPitchnames(pn)
  )
  
  size := method(self intervals size)
  getNameForDegree := method(degree, self pitchnames at(degree - 1))
  
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

silica PitchNames := list("A","Z","B","C","V","D","W","E","F","X","G","Y")

// initial scales
silica ScaleTable new("C-MAJOR", list(2,2,1,2,2,2,1), "C");
// ...