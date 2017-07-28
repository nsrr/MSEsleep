function art=artifact_spectral(sig,fs,hyp)
% sig is my 
deltaBand = [0.5 4.5];
betaBand = [20 40];
th1=2.5;
th2=2.0;
numMovingAvg30secEpochs=15;
    % compute epoch by epoch power spectrum
    epochnum=hyp(:,1);
    spec=[];
    for kk=1:length(epochnum)
        try
        win=sig((epochnum(kk)-1)*30*fs+1:epochnum(kk)*30*fs);
        [pxx,F] = pwelch(win,tukeywin(4*fs),[],[],fs);
        spec(kk,:)=pxx;
        end
    end
    pxx=spec';
    
    deltaStart = find(F>=deltaBand(1));
    deltaStart = deltaStart(1);
    deltaEnd = find(F<deltaBand(2));
    deltaEnd = deltaEnd(end);
    betaStart = find(F>=betaBand(1));
    betaStart = betaStart(1);
    betaEnd = find(F<betaBand(2));
    betaEnd = betaEnd(end);
    
    % Compute artifact detection
    deltaSpectrum = sum(pxx(deltaStart:deltaEnd,:),1);
    deltaMovingRatio = deltaSpectrum./moving(deltaSpectrum, numMovingAvg30secEpochs)';
    betaSpectrum = sum(pxx(betaStart:betaEnd,:));
    betaMovingRatio = betaSpectrum./moving(betaSpectrum, numMovingAvg30secEpochs)';
    
    deltaArtifactMask = deltaMovingRatio > th1;
    betaArtifactMask = betaMovingRatio > th2;
    art=(deltaArtifactMask | betaArtifactMask)';