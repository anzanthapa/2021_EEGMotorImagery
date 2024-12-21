# EEG Signal Analysis for Movement Imagery Classification

## Overview

This project investigates the classification of motor imagery tasks using Electroencephalogram (EEG) signals within Brain-Computer Interfaces (BCIs). By analyzing neural activities associated with imagining movements of the left hand, right hand, both feet, and tongue, the study aims to identify distinctive EEG patterns that can be leveraged to control external devices.

## Abstract

In brain-computer interfaces (BCIs), utilizing different neural activities to control external devices is a complex task. This project aims to identify distinctive characteristics in EEG signals associated with motor imagery, which can be used as control commands for external devices. Time-domain analysis using average Event-Related Potentials (ERP) and frequency-domain analysis using Fast Fourier Transform (FFT), spectrograms, and power spectral density were employed. The study found significant differences in the delta band power spectral values between left hand, right hand, both feet, and tongue movement imagery. However, differentiation in delta and alpha bands was not discernible as initially hypothesized. Spectrogram analysis revealed temporal variations in power spectral density associated with different tasks. The conclusion emphasizes the feasibility of differentiating motor imagery tasks in the delta band, contributing to the advancement of EEG-based BCI systems.

## Introduction

Brain-Computer Interfaces (BCIs) establish a direct connection between the human brain and external devices, capturing neural activities associated with specific mental tasks without involving nerves or muscles. These interfaces interpret brain activities to execute commands, such as controlling robotic arms, wheelchairs, and computers. While methods like functional Magnetic Resonance Imaging (fMRI), Electrocorticography (ECoG), and Magnetoencephalography (MEG) exist, Electroencephalography (EEG) is predominantly used in BCIs due to its non-invasive nature, cost-effectiveness, superior time resolution, and ease of use.

This project hypothesizes that during motor imagery, neural activities in delta, theta, and alpha bands can be differentiated based on the type of imagined movement. Feature extraction from clean EEG signals is critical, necessitating the removal of artifacts such as ocular, muscular, cardiac, and instrumentation noise. The extracted features are then used to interpret the association between motor imagery and neural activity.

## Methods and Analysis

### Dataset

The study utilizes the **BCI Competition IV 2a** dataset, comprising EEG data from 9 subjects recorded using 22 Ag/AgCl electrodes following the international 10-20 system electrode placement. The dataset involves four motor imagery tasks:
1. Left Hand Movement Imagery
2. Right Hand Movement Imagery
3. Both Feet Movement Imagery
4. Tongue Movement Imagery

Each subject participated in two sessions recorded on different days, with each session containing 6 runs separated by short breaks. Each run consists of 48 trials (12 trials per task), totaling 288 trials per session.

### Preprocessing

1. **Data Selection:** Focused on one run from one session for the first subject, encompassing 48 trials across 4 channels (FCz, C3, Cz, C4). The analysis window was set from 2 to 6 seconds post-cue onset.

2. **Artifact Removal:**
   - **Time-Domain Analysis:** Calculated average ERP to suppress Gaussian-distributed noise.
   - **Frequency-Domain Analysis:** Applied FFT to analyze frequency magnitude distribution. An 8th-degree IIR low-pass filter with a 12 Hz cutoff was used to remove high-frequency noise using MATLAB's `filtfilt` function for zero-phase filtering.

3. **Spectrogram Analysis:** Utilized a Hamming window of 125 samples with 100 points overlapping and 250 FFT points to compute power spectral density, providing a time-frequency representation.

4. **Power Spectral Calculation:** 
   - **Delta Band (1-3 Hz):** FFT points 5-13
   - **Theta Band (4-7 Hz):** FFT points 17-29
   - **Alpha Band (8-12 Hz):** FFT points 33-49

## Results

- **Delta Band Differentiation:** Successfully distinguished between left hand, right hand, both feet, and tongue imagery tasks based on delta band power spectral differences.
- **Theta and Alpha Bands:** Limited differentiation observed; only tongue imagery showed notable distinctions from other tasks.
- **Spectrogram Insights:** Revealed temporal variations in power spectral density corresponding to motor imagery execution phases around 3.5 to 4 seconds post-cue.

## Conclusion

The analysis confirms that EEG signals contain discernible patterns in the delta band that can effectively differentiate between various motor imagery tasks. While high-frequency noise was mitigated through averaging and filtering, the study highlights the delta band's robustness in distinguishing imagined movements. These findings contribute to the advancement of EEG-based BCI systems, enabling more reliable and intuitive control of external devices through neural activity interpretation.