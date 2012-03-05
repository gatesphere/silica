#!/usr/bin/env bash

CP=lib/jfugue.jar:lib/processing.jar:classes/.

echo "Running siren..."
if [[ $OSTYPE == linux-gnu ]]; then
  java -cp $CP SIREN
elif [[ $OSTYPE == cygwin ]]; then
  java -cp `cygpath -wp $CP` SIREN
else 
  echo "Unknown platform."
fi
echo "Done."
