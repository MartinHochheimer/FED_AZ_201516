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



link-MRI-files()
{


    # give dir, subdir and sequence-nametag for files to count
    DIR=$1
    SUBDIR=$2
    SEQUENCE=$3
    TARGETDIR=$4

    PATHLIST=${DIR}/${SUBDIR}*/${SEQUENCE}*

    for dir in $PATHLIST; do
	TREECUT=${dir#${DIR}} # use the value of dir except the value of DIR
	MYDIR=${PWD}/${TARGETDIR}/${TREECUT}
	mkdir -p $MYDIR && echo $MYDIR # be aware of current directory, as a wrong one might cause errors in the dirs that are made
        ln -sf ${dir}/* $MYDIR
	echo "softlinked ${dir} to ${MYDIR}"
    done
}
