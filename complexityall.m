function complexityall(datafolder,resultfolder, ...
    analysissignals, referencesignals, referencemethod, ...
    ecgName, start, xmlsuffix)

% please report bugs to sara.mariani7@gmail.com
if referencemethod==1
    referencesignals=repmat(referencesignals,length(analysissignals),1);
end
toplabels=cell(1,length(analysissignals)*5+1);
toplabels(2:5:end)=analysissignals;
lab_art=cell(1,length(analysissignals));
for jj=1:length(lab_art)
    lab_art{jj}=['artifact_' analysissignals{jj}];
end
labels=[{'epochs'},{'hypnogram'},lab_art,analysissignals];
% for jj=2:length(analysissignals)
%     labels=[labels, analysissignals{jj}, {[]} {[]} {[]} {[]}];
% end
files=dir([datafolder './*.edf']);
files=files(start:end);
names=cell(length(files),1);
CI=zeros(length(files),length(analysissignals));
stageall=zeros(length(files),length(analysissignals)*5);
pptFn = ('Complexity_profiles.ppt');
pptPathFn = strcat(resultfolder, pptFn);
ppt = saveppt2(pptPathFn,'init');
for jj=1:length(files)
    EDFfile=[datafolder '\' files(jj).name];
    names{jj}=files(jj).name(1:end-4);
    XMLfile=[EDFfile(1:end-3) xmlsuffix];
    [CI,stagenums,hyp,art]=complexdomain(EDFfile,XMLfile,analysissignals,...
        referencesignals,ecgName);
    % create spreadsheet for this individual subject
    totalPowerFn = ([resultfolder files(jj).name(1:end-4) '_ci.xlsx']);
    totalSummary=[num2cell(hyp) ...
        num2cell(art)];
    for kk=1:length(analysissignals)
        totalSummary=[totalSummary cellstr(num2str(CI(:,kk)))];
    end
    totalSummary=[labels;totalSummary];
    xlswrite(totalPowerFn, totalSummary);
    stageall(jj,:)=stagenums;
    % print figure on Powerpoint
    CI=mean(CI,2);
    art=ceil(mean(art,2));
    figure
    ax(1)=subplot(211);
    plot(hyp(:,1),hyp(:,2))
    ylabel('Sleep stages')
    t=names{jj};
    t=strrep(t,'_',' ');
    title(t)
    ylim([-0.5 5.5])
    set(gca,'ytick',[0:3 5],'yticklabel', ...
        [{'W'},{'N1'},{'N2'},{'N3'},{'REM'}], ...
        'fontsize',18)
    ax(2)=subplot(212);
    plot(hyp(:,1),CI)
    hold on
    CI(find(art))=NaN;
    plot(hyp(:,1),CI)
    xlabel('Time (s)')
    ylabel('CI')
    legend('raw CI', 'after artifact removal')
    set(gca,'fontsize',18)
    linkaxes(ax,'x')
    saveppt2('ppt', ppt);
    close
end
saveppt2(pptPathFn,'ppt',ppt,'close');
% create summary spreadsheet for all subjects
totalPowerFn =([resultfolder '\cisummary.xlsx']);
lab=cell(1,length(analysissignals)*5+1);
lab(1)={'Subject'};
lab(2:5:end)={'wake'};
lab(3:5:end)={'N1'};
lab(4:5:end)={'N2'};
lab(5:5:end)={'N3'};
lab(6:5:end)={'N4'};
STAGEALL=num2cell(stageall);
mymat=[names STAGEALL];
mymat=[toplabels;lab;mymat];
xlswrite(totalPowerFn, mymat);
