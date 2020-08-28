# autoERP
LNS automated matlab scripts for computing ERPs from raw bdf files with 64 electrodes.
The autoERP scripts package has been programmed by Hugo Najberg and Corentin Wicht from the Laboratory of Neurorehabilitation Science (https://www3.unifr.ch/med/spierer/en/), Fribourg, Switzerland, and was supported by the SNSF and doc.ch funds.

## Acknowledgments: 
Dr. Lucas Spierer, Dr. Michael Mouthon, and Dr. Michael De Pretto provided substantial advice on the pre-processing pipeline, ergonomy and testing.

## Description:
Flexible and adaptable to all designs and folder trees.
All steps can be skiped. All default values can be modified.
A log is generated after each run to explicit what was done to the files.

**Script order and details:**

### 1) Filter_epoching.m
This script filters, implements .mrk and epochs .bdf or .set.
You can create and save your epoching parameters in a .mat file to re-load it in a future use of this script.

Filtering pipeling:
1. Re-reference
2. Bandpass filtering
3. Remove sinusoidal noise (CleanLine)
4. Detect blinks
5. ASR filtering
6. Remove the detected blinks in 4.
7. Baseline correction

At the end of epoching, a to_interpolate.xlsx file is generated. You can write in it the bad channels and load them during the ERPs script.

### 2) comp_ICA.m (optionnal)
After having manually computed ICA, you can load the concerned .set to choose the components you want to remove.
For each folder, you will have the topography of the component, the scroll of their activation and the full eeg data scroll to take your decision. ! This decision is asked only once per subfolder !
-> After rejecting the components, you can epoch them wihout filtering them with the Filter_epoching.m script with your saved epoching parameters.


### 3) ERPs.m
1. Reject epochs containings artifacts while ignoring bad channels: 80uV threshold criterion and 30uV jumps
2. Compute the ERP based on averaging parameters 
4. Interpolate the bad channels
5. Compute the average reference or reference to Cz

You can create and save your averaging parameters to re-load it in a future use of this script.
If no merging condition and no events are given, each file will be averaged on all its epochs.
At the end of the run, a .xlsx file named Ntrials is generated. It contains the number of epochs at the start, deleted during artifacts rejection, and in the final ERPs.

