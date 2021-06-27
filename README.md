# FED_AZ_201516

Source code material for my  Master's thesis in Translational Neuroscience and Psychology. \
It utilises nipype and a docker image for easy distribution and access of the
analysis scheme. \
-> Always use latest Dockerfile for built (number index)^^

The thesis' integral components are behavioural data integrated with fMRI
timeseries. The notebooks whose names include the term ``VBM'' are part of a
previous project and kept solely for documentation and reference purposes.
They may be ignored for the present. \\

This work is roughly split into 7 jupyter notebooks, each with its own task:
1. Behavioural (reaction time (RT)) data preparation and analysis
   [jupyter notebook](data_funclib_scripts_exec/RT_data-analysis.ipynb)

2. Dicom to Nifti file conversion
   [jupyter notebook](data_funclib_scripts_exec/fMRI_Dicom2Nifti.ipynb)

3. Distortion correction with optional fieldmap creation (if the data needs it)
   [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_distcor.ipynb)

4. Preprocessing of functional and anatomical data (using FSL & SPM) consisting
   of (in the following order): \
   i.    brain extraction (struct) \
   ii.   motion correction (func) \
   iii.  motion-based artefact correction using rapidart's ART (func) \
   iv.   brain extraction (func) \
   v.    coregistration using Boundary Based Registration (6DOF) (struct & func) \
   vi.   masked smoothing (different mm Kernel, custom intensity and brightness
   thresholds) (func) \
   vii.  masking of the new files and mask creation for 1st level stats (struct
   & func) \
   [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_preppipeline-struc&func.ipynb)

5. 1st level modelling and statistics
   [jupyter notebook](data_funclib_scripts_exec/fMRI_1stlevel.ipynb)

6. 2nd level modelling and statistics
   [jupyter notebook](data_funclib_scripts_exec/fMRI_2ndlevel.ipynb)

7. creation of result figures and plots
   [jupyter notebook](data_funclib_scripts_exec/fMRI_plots_resultfigures.ipynb)

Additionally, a further notebook is  used to create the datastructure for this
analysis, a nested dictionary that extracts, collects and holds all relevant
files and parameters.

It first creates the "original" datastructure without any of the
preprocessing parameters. [jupyter notebook](data_funclib_scripts_exec/fMRI_prestats_data-struct.ipynb)
It also imports the required modules for the entire
analysis! This might seem redundant at times, but is my modus operandi here.
Next, it checks for the completion of those preprocessing steps
that generate additional parameters or changes to the structure and executes them.
The preprocessing notebook is marked at the points where parameter estimation
has been executed in the data notebook.
Files are not "outsourced" in this way, but added during the script
using a custom update function for the file list in the datastructure.

For debugging and experimentation, it is also possible to execute only the
initial datastructure which takes a lot less time to run than its complimentary.

The relevant computational environment is specified in the relevant
Dockerfile_FED-v{latest_version}_nipype.

Additional data, configuration files or processing sripts can be mounted in to
create a more complex command (and also a richer environment) for the docker container execution:

'docker run -it --rm -v /data_directory/:/docker_directory -v /config_directory:/docker_config_directory -p 8888:8888 --name name:tag:version jupyter lab --ip=0.0.0.0'

In case of multiple additions, it is best to write an alias to simplify the
command line.


LICENSE: \
All the source code developed by me, is licensed under a GP license ([version 3](https://www.gnu.org/licenses/gpl-3.0.html)). \
Please view the project's "LICENSE" file to learn more.
