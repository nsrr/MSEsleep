# MSEsleep
Computes "complexity" profiles from sleep EEG using Multiscale Entropy
This tool calculates the Complexity Index (sum of the first 5 scales of Multiscale Entropy) for EEG epochs of default length 30 s. 

It is based on the paper "Mariani, S., Borges, A.F., Henriques, T., Thomas, R.J., Leistedt, S.J., Linkowski, P., Lanquart, J.P., Goldberger, A.L. and Costa, M.D., 2016, August. Analysis of the sleep EEG in the complexity domain. In Engineering in Medicine and Biology Society (EMBC), 2016 IEEE 38th Annual International Conference of the (pp. 6429-6432). IEEE."

The tool has a GUI that allows the user to select the folder with data in NSRR format (EDF for signals and XML for sleep stage annotations). ECG artifact rejection is applied and the MSE is computed using a Matlab wrapper to Madalena Costa's mse.c function.

### Note: you need to have the wfdb Matlab toolbox installed to be able to use msentropy.m https://physionet.org/physiotools/matlab/wfdb-app-matlab/

The tool returns: a spreadsheet for each recording reporting the epoch-by-epoch CI alongside with artifacted epochs for each lead; a global Powerpoint file with figures showing the complexity profile for each recording together with the hypnogram; a global spreadsheet reporting median CI values for each sleep stage and recording after the removal or artifacted epochs.

Artifacted epochs are removed both based on local outliers in spectral power (Achermann, P., Dijk, D.J., Brunner, D.P. and Borbély, A.A., 1993. A model of human sleep homeostasis based on EEG slow-wave activity: quantitative comparison of data and simulations. Brain research bulletin, 31(1), pp.97-113.), and based on comparison of the CI in each epoch with adjacent epochs and a threshold criteria. For more info on the rationale behind this approach, see Mariani, S., Borges, A.F., Henriques, T., Goldberger, A.L. and Costa, M.D., 2015, August. Use of multiscale entropy to facilitate artifact detection in electroencephalographic signals. In Engineering in Medicine and Biology Society (EMBC), 2015 37th Annual International Conference of the IEEE (pp. 7869-7872). IEEE. 

Acknowledgements:
saveppt2:  Used to create PPT summaries from MATLAB figures.
http://www.mathworks.com/matlabcentral/fileexchange/19322-saveppt2

blockEDFLoadClass: Used to quickly load an EDF file. By Dennis Dean.
https://www.mathworks.com/matlabcentral/fileexchange/45227-blockedfloadclass

loadCompumedicsAnnotationsClass: used to load hypnogram annotations from XML file.
https://github.com/DennisDean/LoadCompumedicsAnnotationsClass

please report any bugs/questions to sara.mariani7@gmail.com
