// silica programming language
// Jacob M. Peck
// home module - scales

if(?REPL_DEBUG, writeln("    + Initializing default scales..."))

silica ModeTable table values foreach(mode,
  silica PitchNames foreach(tonic,
    silica ScaleTable new(tonic .. "-" .. mode name, mode, tonic)
  )
)

home := silica namespace("home")
tt := silica TokenTable

silica ScaleTable table values foreach(scale,
  name := scale name
  ctx := Object clone
  ctx x := scale
  tt add(
    home, 
    (name .. "$") asMutable lowercase, 
    silica ScaleChanger with(name .. "$" asMutable uppercase, 
        "Attempts to relatively push the scale " .. name .. " onto the scalestack.", 
        block(
          silica Note changeScale(x)
        ) setScope(ctx)
  ))
  tt add(
    home, 
    name asMutable lowercase, 
    silica ScaleChanger with(name asMutable uppercase, 
        "Absolutely pushes the scale " .. name .. " onto the scalestack.", 
        block(
          silica Note changeScaleRelative(x)
        ) setScope(ctx)
  ))
)

silica ModeTable table values foreach(mode,
  name := mode name
  ctx := Object clone
  ctx x := mode name
  tt add(
    home,
    name asMutable lowercase,
    silica ScaleChanger with(name asMutable uppercase,
        "Relatively pushes the " .. name .. " scale matching the note's current pitch class onto the scalestack.",
        block(
          tonic := silica Note scale last getNameForDegree(silica Note degree)
          scalename := tonic .. "-" .. x asMutable uppercase
          silica Note changeScaleRelative(silica scale(scalename))
        ) setScope(ctx)
  ))
)