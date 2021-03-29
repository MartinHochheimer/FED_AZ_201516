#!/bin/bash
# Execute all of the following out of the FED directory!

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

    # Next, replace lines in fsf file with desired input to FEAT analysis:
    # input correct output directory
    # no temporal highpass filtering - already did that
    # set smoothing kernel to 5mm, but set smoothing to 0 in the next line - already did that
    # set registration to standard space right, but leave switched-off (FSL readability^^)
    # set within subject registration to BBR
    # turn threshold value to 0 (median intensity normalised to 10000 and twice-assured)
    # switch to only performing stats and not post-stats; switch off posstats; switch off timeseries plots
    # insert highres for plotting statistics
    # inserting the correct feat analysis file and path
    # take away the . to switch to absolute paths (see below)
    sed -in -e "/outputdir/s/run0/$OUTPUT_DIRECTORY/"\
           -e "/temphp_yn/s/1/0/"\
           -e "/fmri(smooth)/s/0/5/"\
           -e "/fmri(regstandard)/s/MNI152/\/media\/storage\/data\/fsl\/data\/standard\/MNI152_T1_2mm_brain/"\
           -e "/fmri(regstandard_dof)/s/0/12/"\
           -e "/fmri(regstandard_search)/s/90/180/"\
           -e "/fmri(regstandard_nonlinear_yn)/s/0/1/"\
           -e "/highres_dof/s/6/BBR/"\
           -e "/fmri(thresh)/s/3/0/"\
           -e "/fmri(analysis)/s/6/2/"\
           -e "/fmri(poststats_yn)/s/1/0/"\
           -e "/fmri(tsplot_yn)/s/1/0/"\
           -e '/highres_files/s/""//' -e "/highres_files/s/$/$HIGHRES_IMG/" -e '/highres_files/s/.\//".\//' -e '/highres_files/s/ii/ii"/'\
           -e "/feat_files/s/\/fMRI.*ns\//$FEAT_FILE/"\
           -e "s/\.\/fMRI/\/fMRI/g" $file
done

# change relative to absolute paths
for file in $FSF_FILES; do
    sed -in -e 's/\/fMRI/\/media\/storage\/data\/FED-project_UoA_data\/fMRI/g' $file
done
