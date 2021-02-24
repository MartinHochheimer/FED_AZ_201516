#!/bin/bash

# collect all fsf files into a list
FSF_FILES=$(find /media/storage/data/FED-project_UoA_data/fMRI/ -maxdepth 4 -type f -regextype posix-egrep -regex ".*FED007.*run0.fsf.*")

# find the yet suboptimal parts of the fsf file and edit them as required
for file in FSF_FILES; do
    echo $file
    sed -n -e "/outputdir/s/run0//p" $file
done
