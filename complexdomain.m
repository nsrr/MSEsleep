function [CI,stagenums, hyp, art]=complexdomain(EDFfile,XMLfile,labels,referencelabels,ecgName)
% computes epoch-by-epoch complexity index using multiscale
% entropy analysis. Returns time series, average values over
% sleep stages, and figure with hypnogram
% created by Sara Mariani at Brigham and Women's Hospital
% funded by the National Intitutes of Health - National Heart, Lung, and Blood Institute
% National Sleep Research Resource (HL114473)
% July 2017
% uses saveppt2:  Used to create PPT summaries from MATLAB figures.
% http://www.mathworks.com/matlabcentral/fileexchange/19322-saveppt2
% This program is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
% PARTICULAR PURPOSE. 
%
% please report bugs to sara.mariani7@gmail.com
[~, signalHeader, signalCell] = blockEdfLoad(EDFfile,labels);
[~, refsignalHeader, refsignalCell] = blockEdfLoad(EDFfile,referencelabels);
% insert here a check for the sampling frequencies;
SR=zeros(1,length(labels));
SR2=zeros(1,length(referencelabels));
for jj=1:length(labels)
SR(jj)=signalHeader(jj).samples_in_record;
end
for jj=1:length(referencelabels)
SR2(jj)=refsignalHeader(jj).samples_in_record;
end
SR=[SR SR2];
if numel(unique(SR))~=1
    error('different sampling rates')
else
    SR=SR(1);
end
  lcaObj = loadCompumedicsAnnotationsClass(XMLfile);
lcaObj = lcaObj.loadFile;
hyp=lcaObj.numericHypnogram;
t=[1:length(hyp)];
hyp=[t' hyp];
if ~isempty(refsignalCell)
for jj=1:length(signalCell)
signalCell{jj}=signalCell{jj}-refsignalCell{jj};
end
end
    % remove ECG artifact
    
    edfObj2 = BlockEdfLoadClass(EDFfile);
    edfObj2.numCompToLoad = 3;      % Don't return object
    edfObj2 = edfObj2.blockEdfLoad;  % Load data
    lab=edfObj2.signal_labels;
    ecgindex=unique(find(strcmpi(lab,ecgName)));
    if isempty(ecgindex)
        % try to look for something similar
        ecgindex=unique([find(~cellfun(@isempty,strfind(lab,ecgName))) ...
            find(~cellfun(@isempty,strfind(lab,upper(ecgName)))) ...
            find(~cellfun(@isempty,strfind(lab,lower(ecgName))))]);
        if isempty(ecgindex)
            warning(['There are no channels named or containing ', ...
                ecgName]);
            ecgName='EKG';
            ecgindex=find(~cellfun(@isempty,strfind(lab,ecgName)));
        else
            ecgindex=ecgindex(1);
            warning(['There are no channels named ', ...
                cell2mat(ecgName) '. The channel ' lab{ecgindex} ' will be used instead'])
        end
    end
        ecg=cell2mat(edfObj2.edf.signalCell(ecgindex));
        fsecg=edfObj2.sample_rate(ecgindex);
        signalCell=ecgDecont(signalCell,SR,ecg,fsecg,labels);
    CI=[];
    art=zeros(length(hyp),length(labels));
    for jj=1:length(labels) % for each signal
        % remove artifact using spectral method
        sig=signalCell{jj};
        A=artifact_spectral(sig,SR,hyp);
        art(:,jj)=A;
        % compute MSE
        values=mseseries(sig,SR);
        CI=[CI sum(values')'];
    end
    % remove artifacts using CI
        CI=denoise(CI,hyp);
        stagenums=[];
       for jj=1:length(labels) % for each signal
           ci=CI(:,jj);
        ci(art(:,jj)==1)=NaN;
        % now group by sleep stage
        w=nanmedian(ci(hyp(:,2)==0));
        n1=nanmedian(ci(hyp(:,2)==1));
        n2=nanmedian(ci(hyp(:,2)==2));
        n3=nanmedian(ci(hyp(:,2)==3));
        rem=nanmedian(ci(hyp(:,2)==5));
        stagenums=[stagenums w n1 n2 n3 rem];
       end
      % save(['CI_' EDFfile(end-11:end-6)],'CI','hyp','art')
end