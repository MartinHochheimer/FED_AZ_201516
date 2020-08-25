#!/bin/bash
# Execute all of the following out of the VBM directory!

# create an indexed array by putting function value into round brackets (if you want ;) )
TEMPLATE_CONTROL=$(sed -n '1p;1q' ../data_funclib_scripts_exec/FED_TemplateAssignments.md | grep -oE 'FED[0-9]{3}')
TEMPLATE_DEPRESSED=$(sed -n '4p;4q' ../data_funclib_scripts_exec/FED_TemplateAssignments.md | grep -oE 'FED[0-9]{3}')

# T1 files to check
FILELIST=$(find ${PWD}/* -maxdepth 2 -type f -name T1*.nii)
# make list of 14 digit numbers to match during replacement
# use a here-string --- stuff after arrows gets transformed to stdin for the command to the left^^
#NUMLIST=$(grep -oE "[0-9]{14}" <<< $FILELIST)

for k in $FILELIST; do
    # parameter expansion split k in everything to and from T1 (not incl)
    # everything up to T1
    k1=${k%%T1*}
    # everything from T1
    k2=${k#*T1*}
    for i in $TEMPLATE_DEPRESSED; do
	# limit loop by testing for GroupAssignment
	if [[ $k1 == *"$i"* && $k2 != *"_DEPt_"* ]]; then
	    # re-assemble and put group ID inbetween k1 and k2
	    echo "Assigning group and renaming file to: ${k1}DEPt_T1${k2} ..."
	    mv ${k} ${k1}DEPt_T1${k2}
	fi
    done
done

for k in $FILELIST; do
    # parameter expansion split k in everything to and from T1 (not incl)
    # everything up to T1
    k1=${k%%T1*}
    # everything from T1
    k2=${k#*T1*}
    for i in $TEMPLATE_CONTROL; do
	# limit loop by testing for GroupAssignment
	if [[ $k1 == *"$i"* && $k2 != *"_CONt_"* ]]; then
	    # cut i out of k to insert GroupAssignment
	    echo "Assigning group and renaming file to: ${k1}CONt_T1${k2} ..."
	    mv ${k} ${k1}CONt_T1${k2}
	fi
    done
done


# rename the rest of the files with "CON", as they were taken out of the Control Group -- updated after file inspection in 2020
for k in $FILELIST; do
    # parameter expansion split k in everything to and from T1 (not incl)
    # everything up to T1
    k1=${k%%T1*}
    # everything from T1
    k2=${k#*T1*}
    # limit loop by testing for GroupAssignment
    if [[ $k2 != *"_CONt_"* && $k2 != *"_DEPt_"* && $k2 != *"_CON_"* ]]; then
	echo "Assigning group to files not contained in template: ${k1}CON_T1${k2} ... "
	mv ${k} ${k1}CON_T1${k2}
    fi
done
	

echo "All FED subjects have been assigned to their proper groups ... hopefully ^^"


