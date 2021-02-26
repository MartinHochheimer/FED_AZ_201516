#!/bin/bash
# Execute all of the following out of the VBM directory!

# collect all fsf files into a list
FSF_FILES=$(find ./fMRI/ -maxdepth 4 -type f -regextype posix-egrep -regex ".*FED007.*run0.fsf")

# find the yet suboptimal parts of the fsf file and edit them as required
for file in $FSF_FILES; do
    # print file
    echo $file
    # split string by "/" and create replacement variables
    # need to escape forward slashes, or sed won't take it
    OUTPUT_DIRECTORY="$(cut -d'/' -f1-5 <<<$file --output-delimiter="\/")\/FEAT"
    HIGHRES_IMG="$(cut -d'/' -f1-3 <<<$file --output-delimiter="\/")\/T1_BETBf35.nii"
    NO=0
    echo $OUTPUT_DIRECTORY
    echo $HIGHRES_IMG
    echo $NO
    # replace lines in fsf file with desired input to FEAT analysis
    sed -in -e "/outputdir/s/run0/$OUTPUT_DIRECTORY/" -e "/temphp_yn/s/1/$NO/" -e '/highres_files/s/""//'\
    -e "/highres_files/s/$/$HIGHRES_IMG/" -e '/highres_files/s/.\//".\//' -e '/highres_files/s/ii/ii"/'\
    -e '/feat_files/s/"\//".\//' $file
done
