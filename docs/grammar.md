## silica programming language - grammar

    s -> instr | meta
    instr -> expr | defn
    expr -> token | token expr
    defn -> macrodefn | commanddefn | functiondefn | scaledefn | modedefn
    macrodefn -> macroname '>>' expr
    macroname -> token
    commanddefn -> commandname '=' expr
    commandname -> token
    functiondefn -> functionname '(' params ')' ':=' expr
    functionname -> token
    params -> token | token ',' params
    scaledefn -> scalename '@' tonic '!' modename
    scalename -> token
    tonic -> 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'V' | 'W' | 'X' | 'Y' | 'Z'
    modename -> token
    modedefn -> modename '!!' intervals
    intervals -> number | number intervals
    
    token ->
    number -> 
    meta ->
    