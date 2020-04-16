#!/bin/bash

# write T1 image filenames from VBM directory to anatfiles2.txt
find ./FED* -maxdepth 2 -type f -name T1*.nii > anatfiles2.txt 

# generate the final directory (anatfiles4.txt) to replace old filenames with:
# use backslash indexing in sed to re-assemble filenames from regexs
sed -re 's/([A-Z]{3}[0-9]{3})\/(\w{26}).*([0-9]{14}).*(.nii)/\1\/\1_\2_\3\4/;s/^.{1}//' anatfiles2.txt > anatfiles4.txt


# now use anatfiles4.txt to replace each original filename with the respective replacement

inFILE="anatfiles4.txt"
# make list of 14 digit numbers to match during replacement
FILENUMLIST=$(grep -oE "[0-9]{14}" "$inFILE")
# make file list to replace; remove the dot in find output - pipe to cut
FILEDIRLIST=$(find . -type f -name "T1*.nii" | cut -c 2-)
# search strings in txt file to replace FILEDIRLIST with
FILEREPLIST=$(grep -E ".*[0-9]{14}.*" "$inFILE")
# loop through FILENUMLIST and match number with number in filenames of VBM_FSL
for dir in $FILEDIRLIST; do
    for num in $FILENUMLIST; do
	for rep in $FILEREPLIST; do
	    # stop the 63³ loop by looking for changes (occurence of "FED") in FILEDIRLIST
	    if [[ $dir == *"$num"* && $rep == *"$num"* && $dir != *"FED*FED"* ]]; then
		echo "renaming ${PWD}${dir} to ${PWD}${rep} via mv command ..."
		#mv ${PWD}${dir} ${PWD}${rep}
	    fi
	done
    done
done; echo "All files have been renamed"

	
