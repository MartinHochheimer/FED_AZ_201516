#!/bin/bash
# Interaction with subdir-filecounter
. /media/storage/data/FED-project_UoA_data/file-orga-funcs.sh

echo "Please enter dir, subdir and sequence abbrev(\*) to count files in:"

read x y z

subdir-filecounter $x $y $z
