#!/bin/bash
# source the data function library
#. /media/storage/data/FED-project_UoA_data/data_funclib_scripts_exec/data-funcs.sh
. ${PWD}/data-funcs.sh

replace-subjectID $1 $2 $3 $4
