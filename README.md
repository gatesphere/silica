# silica Programming Language
Copyright 2012 Jacob M. Peck, all rights reserved.

## THIS BRANCH IS DEPRECATED
All new development on silica is in Python.  This branch
is merely historical storage for the Io language prototype
of silica.

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
  * Modular

### Installation
Installing silica can be a bit of a chore, unfortunately.

Here's what you need to do:

  1. Install [Io](http://iobin.suspended-chord.info/).  Preferrably on a 
     linux system.
  2. Install a Java 7 JDK.
  3. Clone this repo.
  4. Build siren: `$ cd siren; ./build.sh`
  5. Set the environment variable `SILICA_DIR` to the repo's root directory.
  6. Run siren: `siren/run.sh`
  7. Run silica: `./silica.io` or `io silica.io`
  8. Pray that everything went well.

### To do:
Here's a short list of things to do:

  * More transforms
    * Implement '->' reduction
  * Modules:
    * Percussion instruments
    * Statistics
    * Algorithmic Composition
    * Microtonal Composition
    * Atonal and Minimalist Composition (Serialists, row-based music, etc)
  * Graphical rendering (siren)
    * Visual representation
    * Pitch mapping (like a sparkline)
    * Duration mapping
    * Octave mapping
    * Chunking
    * Tree structures
  * Give siren a history

### Known bugs:

  * Embedded concurrent voices are broken - siren-side only
    * Problem is that siren assumes the top voice is the lead voice
  * Sometimes the graphical display or the progress bar of siren throws an exception and stops working
  * -display doesn't show all components of a piece
  * :retrograde is broken in some aspects
  * function parameters are not passed deeper than one level (eg. a(x,y) := x b(y), b would not recieve y)
  * parser is slow!
    * orders of magnitude slower with concurrent voices, due to recursive parser call
  * REPL interpretLine should be modular like the parser, to allow further manipulations like transforms
  * REPL default output "okay." is confusing... try -reloadlang without -require(debug) and see what I mean

## Contributing
This is a personal project.  If you have feedback, I'd love to hear it, but code will be mine.  You can contact me at [suschord@suspended-chord.info](mailto:suschord@suspended-chord.info).

## Entry to PLTGames
This project is an entry to the [March 2013 PLTGames contest](http://www.pltgames.com/competition/2013/3).
