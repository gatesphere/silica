// silica programming language
// Jacob M. Peck
// Scale proto

if(?REPL_DEBUG, writeln("  + Loading Scale.io"))

silica Scale := Object clone do(
  name ::= nil
  mode ::= nil
  tonic ::= nil
  pitchnames ::= nil
  
  init := method(
    self name = nil
    self mode = nil
    self tonic = nil
  )
  
  with := method(name, mode, tonic,
    self clone setName(name) setMode(mode) setTonic(tonic) generatePitchnames
  )
  
  generatePitchnames := method(
    pn := list(tonic)
    pos := silica PitchNames indexOf(self tonic)
    last := self mode intervals clone
    last pop
    last foreach(i,
      pos = pos + i
      if (pos > silica PitchNames size - 1, pos = pos - (silica PitchNames size))
      pn append(silica PitchNames at(pos))
    )
    self setPitchnames(pn)
  )
  
  size := method(self mode size)
  getNameForDegree := method(degree, self pitchnames at(degree - 1))
  
  asString := method(
    "SCALE< " .. self name uppercase .. " >"
  )
)

silica ScaleTable := silica EntityTable clone do(
  clone := method(self)
  new := method(name, mode, tonic,
    self table atIfAbsentPut(name, silica Scale with(name, mode, tonic))
  )
)

silica PitchNames := list("A","Z","B","C","V","D","W","E","F","X","G","Y")