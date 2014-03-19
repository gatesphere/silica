<!--@+leo-ver=5-thin-->
<!--@+node:peckj.20130604112211.2168: * @file README.md-->
<!--@@language md-->
# silica Programming Language
Copyright 2012-2013 Jacob M. Peck, all rights reserved.

## License
See the file [license/license.txt](https://raw.github.com/gatesphere/silica/master/license/license.txt).

## Overview
silica is a domain specific language and interpreter for exploring tonal music and cognition.  This project is based heavily on the Clay programming language by Craig Graci, which uses as its featured data type a representation of a musical note.  Clay has many great features, but there are a few ares that I feel it is lacking in, and as such, I'd like to flesh it out a bit.

### What does silica look like?
silica operates on the concept of a single note upon which various manipulations are performed.  In essence, the entire state of a silica program is contained within this abstract notion of a note.  It's much easier to demonstrate than explain, so here's a short suggestive, annotated session with silica.  (Note, silica's note defaults to the C major scale, degree 1, duration 1 (a quarter note), MIDI octave 5, and has persistence between commands)
    
    # let's start by playing a note
    silica(home)> play
    --> C1
    
    # now let's play with pitches
    silica(home)> rp play rp play lp play lp play
    --> / D1 / E1 \ D1 \ C1
    
    # let's do the same thing, but with a repetition factor
    silica(home)> 2rp+play 2lp+play
    --> / D1 / E1 \ D1 \ C1
    
    # let's play a half note
    silica(home)> x2 play s2
    --> C2
    
    # let's define a macro for playing a half note... "play long"
    silica(home)> pl >> x2 play s2
    --> Macro PL defined.
    
    # test it?
    silica(home)> pl
    --> C2
    
    # let's define a structured macro -- a 'group' if you will
    # this is equivalent to 'hat >> begingroup play rp play lp play endgroup'
    silica(home)> hat = play rp play lp play
    --> Macro HAT defined.
    silica(home)> hat
    --> { C1 / D1 \ C1 }
    
    # now let's make a longer piece using hat
    silica(home)> hat3 = hat rp hat lp hat
    --> Macro HAT3 defined.
    silica(home)> hat3
    --> { { C1 / D1 \ C1 } { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } }
    
    # now, a parameterized version of hat
    silica(home)> hatx(x) = x rp x lp x
    --> Macro HATX defined.
    
    # now, play it with a few different parameters
    silica(home)> hatx(play)
    --> { C1 / D1 \ C1 }
    silica(home)> hatx(pl)
    --> { C2 / D2 \ C2 }
    silica(home)> hatx(hat)
    --> { { C1 / D1 \ C1 } { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } }
    silica(home)> hatx(hat3)
    --> { { { C1 / D1 \ C1 } { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } } { { / D1 
    / E1 \ D1 } { / E1 / F1 \ E1 } { \ D1 / E1 \ D1 } } { { \ C1 / D1 \ C1 } 
    { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } } }
    
    # and finally, exit
    silica(home)> -exit
    --> Goodbye!
    
I understand that this isn't exactly clear, but I hope to have more examples at a later date...

### silica-unique features
There are a few things that differentiate silica from Clay.  Here's an extremely short list.

  * Open source
  * User-defined scales and modes
  * Functions
  * Modular

### Installation
Information on this will be given at a later date.

## Contributing
This is a personal project.  If you have feedback, I'd love to hear it, but code will be mine.  You can contact me at [suschord@suspended-chord.info](mailto:suschord@suspended-chord.info).

<!--@-leo-->
