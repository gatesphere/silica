// silica programming language
// Jacob M. Peck
// home module - transforms

if(?REPL_DEBUG, writeln("    + Initializing default transforms..."))

home := silica namespace("home")
tt := silica TokenTable

tt add(home, ":drop", silica Transform with(":DROP", "Removes the last note of whatever it is applied to.",
    block(in, scale,
      in_l := in splitNoEmpties
      pos := in_l size - 1
      loop(
        if(pos < 0, break)
        tok := in_l at(pos)
        if(tok == "play" or tok == "mute" or tok == "rest",
          in_l removeAt(pos)
          break
          ,
          pos = pos - 1
        )
      )
      in_l join(" ")
    )
))
tt add(home, ":double", silica Transform with(":DOUBLE", "Doubles the last note of whatever it is applied to.",
    block(in, scale,
      in_l := in splitNoEmpties
      pos := in_l size - 1
      loop(
        if(pos < 0, break)
        tok := in_l at(pos)
        if(tok == "play" or tok == "mute" or tok == "rest",
          in_l atPut(pos, tok .. " " .. tok)
          break
          ,
          pos = pos - 1
        )
      )
      in_l join(" ")
    )
))
tt add(home, ":invert", silica Transform with(":INVERT", "Inverts the contour of whatever it is applied to.",
    block(in, scale,
      in splitNoEmpties map(tok,
        if(tok == "rp",
          "lp"
          ,
          if(tok == "lp",
          "rp"
            ,
            tok
          )
        )
      ) join(" ")
    )
))
tt add(home, ":retrograde", silica Transform with(":RETROGRADE", "Reverses the order of whatever it is applied to.",
    block(in, scale, 
      // gather information
      contours := list
      durations := list
      play_commands := list
      others := list
      curr_contour := 0 // relative
      curr_duration_stack := list
      curr_duration_recovery := list
      in splitNoEmpties foreach(tok,
        if(tok == "rp", curr_contour = curr_contour + 1)
        if(tok == "lp", curr_contour = curr_contour - 1)
        if(tok == "x2", curr_duration_stack append("x2"); curr_duration_recovery prepend("s2"))
        if(tok == "x3", curr_duration_stack append("x3"); curr_duration_recovery prepend("s3"))
        if(tok == "x5", curr_duration_stack append("x5"); curr_duration_recovery prepend("s5"))
        if(tok == "x7", curr_duration_stack append("x7"); curr_duration_recovery prepend("s7"))
        if(tok == "s2", curr_duration_stack append("s2"); curr_duration_recovery prepend("x2"))
        if(tok == "s3", curr_duration_stack append("s3"); curr_duration_recovery prepend("x3"))
        if(tok == "s5", curr_duration_stack append("s5"); curr_duration_recovery prepend("x5"))
        if(tok == "s7", curr_duration_stack append("s7"); curr_duration_recovery prepend("x7"))
        if(tok == "play" or tok == "rest" or tok == "mute",
          play_commands prepend(tok)
          contours prepend(curr_contour)
          durations prepend(list(curr_duration_stack clone, curr_duration_recovery clone))
          ,
          others append(tok)
        )
      )
      if(?REPL_DEBUG, writeln("TRACE (:retrograde): play_commands = " .. play_commands))
      if(?REPL_DEBUG, writeln("TRACE (:retrograde): contours = " .. contours))
      if(?REPL_DEBUG, writeln("TRACE (:retrograde): durations = " .. durations))
      
      // reverse
      out := list("pushstate") append(others) flatten
      curr_contour = 0
      play_commands foreach(i, pc,
        target_contour := contours at(i)
        target_duration := durations at(i)
        // contour
        while(curr_contour != target_contour,
          if(curr_contour < target_contour,
            curr_contour = curr_contour + 1
            out append("rp")
            ,
            curr_contour = curr_contour - 1
            out append("lp")
          )
        )
        
        // duration
        out append(target_duration first join(" "))
        
        // play command
        out append(pc)
        
        // duration again
        out append(target_duration second join(" "))
      )
      out append("popstate")
      out join(" ")
    )
))
