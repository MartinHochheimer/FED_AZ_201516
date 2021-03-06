#!/bin/bash
# Execute all of the following out of the VBM directory!

# collect all fsf files into a list
FSF_FILES=$(find ./fMRI/ -maxdepth 4 -type f -regextype posix-egrep -regex ".*FED007.*run0.fsf")

# find the yet suboptimal parts of the fsf file and edit them as required
for file in $FSF_FILES; do
    # print file
    echo $file
    # split string by "/" and create replacement variables
    # need to escape forward slashes, sed will interpret and not print them
    OUTPUT_DIRECTORY="$(cut -d'/' -f1-5 <<<$file --output-delimiter="\/")\/FEAT"
    HIGHRES_IMG="$(cut -d'/' -f1-3 <<<$file --output-delimiter="\/")\/T1_BETBf35.nii"
    FEAT_FILE="$(cut -d'/' -f1-3 <<<$file --output-delimiter="\/")\/"
    NO=0
#    echo $OUTPUT_DIRECTORY
#    echo $HIGHRES_IMG
#    echo $FEAT_FILE
#    echo $NO
    # replace lines in fsf file with desired input to FEAT analysis
    # the builder for the fsf file produces an eror in the path of the feat_files. Correct it.
    sed -in -e "/outputdir/s/run0/$OUTPUT_DIRECTORY/"\
           -e "/temphp_yn/s/1/$NO/"\
           -e '/highres_files/s/""//' -e "/highres_files/s/$/$HIGHRES_IMG/" -e '/highres_files/s/.\//".\//' -e '/highres_files/s/ii/ii"/'\
           -e "/feat_files/s/\/fMRI.*ns\//$FEAT_FILE/"\
           -e "s/\.\/fMRI/\/fMRI/g" $file
done


# if needed, change relative to absolute paths
for file in $FSF_FILES; do
    sed -in -e 's/\/fMRI/\/media\/storage\/data\/FED-project_UoA_data\/fMRI/g' $file
done
