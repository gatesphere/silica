#!/usr/bin/env bash

CP=lib/jfugue.jar:lib/processing.jar:.
SRC_DIR=src/
CLASS_DIR=classes/

echo "Building sire..."
javac -cp $CP -sourcepath $SRC_DIR -d $CLASS_DIR $SRC_DIR/*.java
echo "Done."
