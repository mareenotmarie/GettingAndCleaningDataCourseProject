Getting And Cleaning Data Course Project
========================================
Version 1.0
===========

Data collected from experiments with volunteers performing various activities while wearing a smartphone on the waist has been transformed to provide more of a summary of the data.

Data variables of the original dataset that were means or standard deviations of sensor signals or magnitudes have been averaged by volunteer (subject) and activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

The dataset includes the following files:
----------------------------------------
- README.md - this file
- run_analysis.R - the code to generate the transformed dataset from the original dataset
- CodeBook.md -  a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data 
- means.csv - the transformed dataset in csv form
- means.txt - the transformed dataset as a text file

Reading the tidy dataset
------------------------

Use the following code to read in the tidy dataset

`means <- read.table("means.txt", header=TRUE)`




