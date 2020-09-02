#!/bin/bash

EXPANSION=".nii.gz"
FILELIST=$(ls FED*${EXPANSION})
INPUTSTR="_betBf04_struc_brain"
TARGET="/struc/"

# make dir for bet output (will throw an error, if the folder already exists)
mkdir ${PWD}${TARGET}

# put pre and post bet in list for slicesdir-control
IMAGELIST=""
# initiate bet with correct input and output filenames
for i in $FILELIST; do
    OUTFILE=`basename $i $EXPANSION`
    if [[ -f ".${TARGET}${OUTFILE}${INPUTSTR}${EXPANSION}" ]]; then
	echo ".${TARGET}${OUTFILE}${INPUTSTR}${EXPANSION} already exists. skipping and going to next file ..."
    else
	echo " running bet on  ${OUTFILE}${EXPANSION} ..."
	# change bet settings here
	bet $i .${TARGET}${OUTFILE}${INPUTSTR}${EXPANSION} -B -f 0.4 -o
    fi
    IMAGELIST="$IMAGELIST $i .${TARGET}${OUTFILE}${INPUTSTR}${EXPANSION}"
done; echo "all files have been skullstripped ... hopefully correctly ..."

# rename overlay files and remove mask files to avoid crowding
cd .${TARGET}

echo "trimming directory ${PWD} ..."

`rename 's/betBf04_struc_brain_overlay.nii.gz/betBf04_overlay.nii.gz/' *.gz`
rm -f *"${INPUTSTR}"_mask*

echo "${PWD} directory trimmed."

# run slicesdir and write html file for brain-extracted images
echo "running slicesdir to control success of BET ..."
slicesdir -o $IMAGELIST

echo "slicesdir has run. Check out the html file."
