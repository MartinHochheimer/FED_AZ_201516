#!/bin/bash
# Execute all of the following out of the VBM directory!

# collect all fsf files into a list
FSF_FILES=$(find ./fMRI/ -maxdepth 4 -type f -regextype posix-egrep -regex ".*FED007.*run0.fsf")

# find the yet suboptimal parts of the fsf file and edit them as required
for file in $FSF_FILES; do
    # print file
    echo $file
    # split string by "/" and create replacement variables
    # need to escape forward slashes, sed will merely interpret them as escapes
    OUTPUT_DIRECTORY="$(cut -d'/' -f1-5 <<<$file --output-delimiter="\/")\/FEAT"
    HIGHRES_IMG="$(cut -d'/' -f1-3 <<<$file --output-delimiter="\/")\/T1_BETBf35.nii"
    FEAT_FILE="$(cut -d'/' -f1-3 <<<$file --output-delimiter="\/")\/"
#    echo $OUTPUT_DIRECTORY
#    echo $HIGHRES_IMG
#    echo $FEAT_FILE
    # replace lines in fsf file with desired input to FEAT analysis
    # the builder for the fsf file produces an eror in the path of the feat_files. Correct it.
    sed -n -e "/outputdir/s/run0/$OUTPUT_DIRECTORY/"\  # insert correct output directory
           -e "/temphp_yn/s/1/0/p"\  # no temporal highpass filtering - already did that
           -e "/fmri(smooth)/s/0/5/p"\  # set smoothing kernel to 5mm
           -e "/highres_dof/s/6/BBR/p"\  # set within subject registration to BBR
           -e "/fmri(thresh)/s/3/0/p"\   # turn threshold value to 0 (median intensity normalised to 10000 and twice-assured)
#           -e "////p"                 # add correct TE and DwellTime using the .json files
           -e "/fmri(analysis)/s/6/5/p"\ # swithc to only performing stats and not post-stats
           -e '/highres_files/s/""//' -e "/highres_files/s/$/$HIGHRES_IMG/" -e '/highres_files/s/.\//".\//' -e '/highres_files/s/ii/ii"/'\  # insert highres for plotting statistics
           -e "/feat_files/s/\/fMRI.*ns\//$FEAT_FILE/"\  # inserting the correct feat analysis file and path
           -e "s/\.\/fMRI/\/fMRI/g" $file  # take away the . to switch to absolute paths (see below)
done


# if needed, change relative to absolute paths
for file in $FSF_FILES; do
    sed -n -e 's/\/fMRI/\/media\/storage\/data\/FED-project_UoA_data\/fMRI/gp' $file
done
