# Final-Year-Project-2

Year 3 university project for Robert Clark (rc00529), relating to using machine learning to identify chiari-like malformation within Cavalier King Charles Spaniels.

The majority of the code will be developed in MATLAB, with some Python scripts being used for processing of data.

## Dependencies

### Python

* __pydicom__ - For reading terms within DICOM tags of dataset.

### MATLAB

* __Deep Learning Toolbox__ - For all CNN and DLN functionality
* __Image Processing Toolbox__ - For pre-processing the central slices of the MRI scans
* __Computer Vision Toolbox__ - For analysing the central slices of the MRI scans for biomarkers.
* __Deep Learning Toolbox Model for VGG19 Network__ - For the specific DLN used within this project.
* __Parallel Computing Toolbox__ - For faster processing of images by DLN.
