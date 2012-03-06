#!/usr/bin/env bash

CP=lib/jfugue.jar:lib/processing.jar:.
SRC_DIR=src/
CLASS_DIR=classes/

echo "Building siren..."
if [[ $OSTYPE == linux-gnu ]]; then
  javac -cp $CP -sourcepath $SRC_DIR -d $CLASS_DIR $1 $SRC_DIR/*.java
elif [[ $OSTYPE == cygwin ]]; then
  javac -cp `cygpath -wp $CP` -sourcepath $SRC_DIR -d $CLASS_DIR $1 $SRC_DIR/*.java
else
  echo "Unknown platform."
fi
echo "Done."
