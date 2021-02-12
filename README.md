# FED_AZ_201516

Material for my Docker Project and Master's thesis
Analyse data via nipype and use a docker image for easy distribution and access.
Always use latest Dockerfile for built (number index)

This work is roughly split into 6 jupyter notebooks, each with its own task:

1. Dicom to Nifit file conversion
   [jupyter notebook](data_funclib_scripts_exec/fMRI_Dicom2Nifti.ipynb)

2. Distortion correction with optional fieldmap creation (if the data needs it)
   [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_distcor.ipynb)

3. Preprocessing of functional and anatomical data (FSL & SPM), using
   i.    brain extraction
   ii.   motion correction
   iii.  robust intensity masking
   iv.   smoothing (5mm Kernel, custom intensity and brightness thresholds)
   v.    coregistration using Boundary Based Registration
   vi.   masking of the new files and mask creation for 1st level stats
   vii.  double intensity normalisation
   viii. highpass filtering
   [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_preppipeline-struc&func.ipynb)

4. 1st level modeling and statistics
   [jupyter notebook](data_funclib_scripts_exec/fMRI_1stlevel.ipynb)

5. 2nd level modeling and statistics
   [jupyter notebook](data_funclib_scripts_exec/fMRI_2ndlevel.ipynb)

6. creation of result figures and plots
   [jupyter notebook](data_funclib_scripts_exec/fMRI_plots_resultfigures.ipynb)

Additionally, 2 further notebooks are used to create the datastructure for this
analysis, a nested dictionary that extracts, collects and holds all relevant
files and parameters.

The first of them creates the "original" datastructure without any of the
preprocessing parameters. [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_data-struct.ipynb)
It also imports the required modules for the entire
analysis! This might seem redundant at times, but is my modus operandi here.
The second one checks for the completion of thosepreprocessing steps
that generate additonal parameters to the structure and computes them. [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_data-struct2-prepadds.ipynb)
The preprocessing notebook is makred at the points where parameter estimation
has been executed in the secondary data notebook.
Files are not "outsourced" in this way, but added during the script
using a custom update function for the file list in the datastructure.

For debugging and experimentation, it is also possible to execute only the
initial datastructure which takes a lot less time to run that its complimentary.

The relevant computational environment is specified in the relevant
Dockerfile_FED-v{latest_version}_nipype.

Aditional data, configuration files or processing sripts can be mounted in to
create a more complex command (and also a richer environment) for the docker container execution:

'docker run -it --rm -v /data_directory/:/docker_directory -v /config_directory:/docker_config_directory -p 8888:8888 --name name:tag:version jupyter lab --ip=0.0.0.0'

In case of multiple additions, it is best to write an alias to simplify the
command line.
