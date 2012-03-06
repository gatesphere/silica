# silica Programming Language
Copyright 2012 Jacob M. Peck, all rights reserved.

## License
See the file [license/license.txt](https://raw.github.com/gatesphere/silica/master/license/license.txt).

A brief version is as follows:

  * The entirety of the silica code (all of the .io files) is released under a BSD license.
    * silica uses the [io-symbols](https://github.com/gatesphere/io-symbols) library, which is released into the public domain.
  * The source for siren (the silica rendering engine) is released under a BSD license.
    * siren uses the [processing](http://processing.org/) library, which is released under a dual GPL/LGPL license, with parts under the IBM Public License.
    * siren uses the [JFugue](http://jfugue.org/) library, which is released under a LGPL license.
    * siren uses the [DejaVu Serif Book](http://dejavu-fonts.org/wiki/Main_Page) font, which is released under an open, free-usage license.
  * The silica documentation and logo are released under a creative commons license (BY-ND-3.0).

## Overview
silica is a domain specific language and interpreter for exploring tonal music and cognition.  This project is based heavily on the Clay programming language by Craig Graci, which uses as it's featured data type a representation of a musical note.  Clay has many great features, but there are a few ares that I feel it is lacking in, and as such, I'd like to flesh it out a bit.

### What does silica look like?
silica operates on the concept of a single note upon which various manipulations are performed.  In essence, the entire state of a silica program is contained within this abstract notion of a note.  It's much easier to demonstrate than explain, so here's a short suggestive, annotated session with silica.  (Note, silica's note defaults to the C major scale, degree 1, duration 1 (a quarter note), MIDI octave 5, and has persistence between commands)
    
    ## lets start by playing a note
    silica> play
    --> C1
    
    ## now let's play with pitches
    silica> rp play rp play lp play lp play
    --> / D1 / E1 \ D1 \ C1
    
    ## let's do the same thing, but with a repetition factor
    silica> 2rp+play 2lp+play
    --> / D1 / E1 \ D1 \ C1
    
    ## let's play a half note
    silica> x2 play s2
    --> C2
    
    ## let's define a macro for playing a half note... "play long"
    silica> pl >> x2 play s2
    --> -macro home::PL defined
    
    ## test it?
    silica> pl
    --> C2
    
    ## let's define a command... a command is a macro with embedded structure... you'll see
    silica> hat = play rp play lp play    
    --> COMMAND home::HAT defined.
    silica> hat
    --> { C1 / D1 \ C1 }
    
    ## now let's make a longer piece using hat
    silica> hat3 = hat rp hat lp hat
    --> COMMAND home::HAT3 defined.
    silica> hat3
    --> { { C1 / D1 \ C1 } { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } }
    
    ## now, a function (notice, macros, commands, and functions all share a namespace)
    silica> fn_hat(x) := x rp x lp x
    --> FUNCTION home::FN_HAT defined.
    
    ## now, play it with a few different parameters
    silica> fn_hat(play)
    --> C1 / D1 \ C1
    silica> fn_hat(pl)
    --> C2 / D2 \ C2
    silica> fn_hat(hat)
    --> { C1 / D1 \ C1 } { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 }
    silica> fn_hat(hat3)
    --> { { C1 / D1 \ C1 } { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } } { { / D1 
    / E1 \ D1 } { / E1 / F1 \ E1 } { \ D1 / E1 \ D1 } } { { \ C1 / D1 \ C1 } 
    { / D1 / E1 \ D1 } { \ C1 / D1 \ C1 } }
    
    ## and finally, exit
    silica> -exit
    --> META> -EXIT
    
    
I understand that this isn't exactly clear, but I hope to have more examples at a later date...

### silica-unique features
There are a few things that differentiate silica from Clay.  Here's an extremely short list.

  * Open source
  * User-defined scales and modes
  * Functions
  * Muted notes

### To do:
Here's a short list of things to do:

  * Comments in script files
  * Error handling
  * Percussion instruments
  * Sonic/Graphical rendering (siren)

### Known bugs:

  * meta commands allowed intermixed with other symbols in the same line
  * -display doesn't show all components of a piece

## Contributing
This is a personal project.  If you have feedback, I'd love to hear it, but code will be mine.  You can contact me at [suschord@suspended-chord.info](mailto:suschord@suspended-chord.info).
