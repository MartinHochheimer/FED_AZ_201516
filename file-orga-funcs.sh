# Bash Family Shell Dictionary for file organisation

subdir-filecounter()
{
    # give dir, subdir and sequence-nametag for files to count
   DIR=$1
   SUBDIR=$2
   SEQUENCE=$3

    PATHLIST=${DIR}/${SUBDIR}*/${SEQUENCE}*

    for files in $PATHLIST; do
	echo ${PWD}/$files
	NUMS=`ls -a $files | wc -l` # bash does not seem to recognize my aliases in own functions ... maybe look into dot sourcing in my bash aliases or some more elegant way ...
	FILENUMS=`expr $NUMS - 2` # get rid of directory references in ls command 
	echo "$FILENUMS files."
    done
    
}

