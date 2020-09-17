# Bash Family Shell Dictionary for data organisation and manipulation | FED project

# count files in dir, using studyname and filenames (conceived for counting raw MRI data before dicom import)
subdir-filecounter()
{
    # give dir, subdir and sequence-nametag for files to count
   DIR=$1
   SUBDIR=$2
   SEQUENCE=$3

    PATHLIST=${DIR}/${SUBDIR}*/${SEQUENCE}*

    for files in $PATHLIST; do
	echo ${PWD}/$files
	FILENUMS=`ls --almost-all --ignore-backups $files | wc -l` # bash does not seem to recognize my aliases in own functions ... maybe look into dot sourcing in my bash aliases or some more elegant way ...
	echo "$FILENUMS files."
    done

}

# count all volumes in your fMRI files using studyname and filenames (conceived for QC of fMRI task data)
subdir-volcounter()
{
    # give dir, subdir and sequence-nametag for files to count
   DIR=$1
   SUBDIR=$2
   FILE=$3

    PATHLIST=${DIR}/${SUBDIR}*/${FILE}*

    for file in $PATHLIST; do
	echo $file
	FILENUMS=`fslnvols ${file}`
	echo "$FILENUMS volumes in this NIFTI."
    done

}


link-MRI-files()
{


    # give dir, subdir and sequence-nametag for files to count
    # targetdir to specify where it should be linked to
    DIR=`realpath $1` # use "realpath" this to get full path from root down to analysis directory
    SUBDIR=$2
    SEQUENCE=$3
    TARGETDIR=`realpath $4` # use "realpath" to get correct value of MYDIR downstream

    PATHLIST=${DIR}/${SUBDIR}*/${SEQUENCE}*

    for dir in $PATHLIST; do
	echo $dir
	TREECUT=${dir#${DIR}} # use the value of dir except the value of DIR
	MYDIR=${TARGETDIR}${TREECUT}
	if [ -d "$MYDIR" ]; then
	    ln -sf ${dir}/* $MYDIR
            echo "softlinked ${dir} to existing directory: ${MYDIR}."
	else
	    mkdir -p $MYDIR && echo $MYDIR # be aware of current directory, as a wrong one might cause errors in the dirs that are made
            ln -sf ${dir}/* $MYDIR
	    echo "softlinked ${dir} to new directory: ${MYDIR}."
	fi
    done
}


replace-subjectID()
{
    # set up dir for find command
    DIR=$1
    NAME=$2
    DELSTR=$3
    REPSTR=$4

    FILELIST=$(find ${DIR} -maxdepth 2 -name ${NAME}*)

    for i in $FILELIST; do
    rename -n -e "s/$DELSTR/$REPSTR/" $i
    done

    echo "Do you wish to rename the selected files as shown above? (type the number of the answer to be selected)"
    select yn in "Yes" "No"
    do
    case $yn in
        Yes) for i in $FILELIST; do
        rename -e "s/$DELSTR/$REPSTR/" $i
        done; echo "Subject IDs have been replaced.";
        exit;;

        No) echo "Replacing Subject IDs has been aborted at user's request.";
        exit;;
    esac
    done
}
