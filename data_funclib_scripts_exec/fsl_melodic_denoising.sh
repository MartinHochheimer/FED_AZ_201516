#!/bin/bash

# create file that contains all files that should be run through melodic
BASEDIR="/media/storage/data/FED-project_UoA_data/fMRI"
FILE_INDICES={06..68} # does not yet work - WIP!
REGEX="^.*FMRI.*[0-9]{14}.nii"

FILELIST=$(find ${BASEDIR}/FED0* -type f -regextype posix-extended -regex ${REGEX})

# write filelist to file in directory
echo $FILELIST > ${BASEDIR}/melodic_FSLcompare

# read the file and execute FSL melodic for each element in it
LINES=$(cat ${BASEDIR}/melodic_FSLcompare)

for line in $LINES; do
    echo "melodic -i ${line} -o ${line%/*}/melodic_FSL604 --report"
done
