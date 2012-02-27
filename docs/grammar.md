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
    tonic -> 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'V' | 'W' | 'X' | 'Y' | 'Z'
    modename -> token
    modedefn -> modename '!!' intervals
    intervals -> number | number intervals
    
    token -> 'A'..'z' | number | 'A'..'z' token | number token
    number -> '0'..'9' | '0'..'9' number
    meta -> '-' token
    
The above grammar does not account for transformations or comments.
