# autoERP
LNS automated Matlab scripts for pre-processing raw EEG signal into filtered epoched data (Filtering_epoching.m), doing ICA to reject blink components (Comp_ICA.m), and computing ERPs after interpolation and artefact rejection (ERPs.m).

**⚠️ Currently only compatible with raw .bdf and .set files with 64 channels**

## Description:
Flexible and adaptable to all designs and folder trees.

All steps can be skiped. All default values can be modified.

A log is generated after each run to explicit what was done to the files.

*For more information to how to get started, please refer to the **User Manual**.*

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

At the end of epoching, a to_interpolate.xlsx file is generated. You can write in it the bad channels and load them during the ERPs script. Do not erase the first example line of the to_interpolate.xlsx file.

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

## Dependencies
| PLUGINS | Description |
| ------ | ------ |
| [BLINKER v1.1.2](http://vislab.github.io/EEG-Blinks/) | BLINKER  is an automated pipeline for detecting eye blinks in EEG and calculating various properties of these blinks | 
| [CleanLine v1.04](https://github.com/sccn/cleanline) | This plugin adaptively estimates and removes sinusoidal (e.g. line) noise from your ICA components or scalp channels using multi-tapering and a Thompson F-statistic |
| [Clean_rawdata v2](https://github.com/sccn/clean_rawdata)| This plugin is used solely for the vis_artifacts.m function for the ICA script |
|[EEGInterp](https://d-nb.info/1175873608/34)| This package provides multiquadratics interpolation algorithms which were deemed the best one tested for good signal quality |
| [EEGLAB v14.1.2b](https://github.com/sccn/eeglab) | Main software that manages most of the preprocessing and analyses toolboxes described in the table below |

Isolated functions:
* [saveeph](https://sites.google.com/site/cartoolcommunity/files)
* [natsort](https://ch.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort)

The dependencies are already included and loaded automatically in the Functions folder.

## Authors
[**Hugo Najberg**](https://www3.unifr.ch/med/spierer/en/group/team/people/194247/8d66b)\
*SNSF PhD student*\
*hugo.najberg@unifr.ch, hugo.najberg@gmail.com*\
*[Laboratory for Neurorehabilitation Science](https://www3.unifr.ch/med/spierer/en/)*\
*University of Fribourg, Switzerland*

[**Corentin Wicht**](https://www.researchgate.net/profile/Wicht_Corentin)\
*SNSF Doc.CH PhD student*\
*corentin.wicht@unifr.ch, corentinw.lcns@gmail.com*\
*[Laboratory for Neurorehabilitation Science](https://www3.unifr.ch/med/spierer/en/)*\
*University of Fribourg, Switzerland*

## Cite the repository
H. Najberg, C.A. Wicht, autoERP, (2020), GitHub repository https://github.com/HugoNjb/autoERP

## License
<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

See the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments: 
[PD Dr. Lucas Spierer](https://www.researchgate.net/profile/Lucas_Spierer) from the University of Fribourg provided substantial support and advices regarding theoretical conceptualization as well as access to the workplace and the infrastructure required to successfully complete the project. Additionally, [Dr. Michael Mouthon](https://www3.unifr.ch/med/fr/section/personnel/all/people/3229/6a825) and [Dr. Michael De Pretto](https://www3.unifr.ch/med/fr/section/personnel/all/people/117251/7303f) provided substantial advice on the pre-processing pipeline, ergonomy and testing.

## Fundings
This project was supported by a grant from the Velux Foundation (Grant #1078 to LS); from the Swiss National Science Foundation (Grant #320030_175469 to LS); and from the Research Pool of the University of Fribourg to PD Dr. Lucas Spierer.
