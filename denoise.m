function CI2=denoise(CI,hyp)
% denoising process of the CI time series according
% to Filipa :-)
% an abrupt change of complexity (?CI) of more than 3 units 
% (adimensional) inside the same sleep stage is considered 
% lacking any physiological meaning and the correspondent 
% CI value discarded. This filtering procedure is reproduced 
% iteratively five times 
% hyp has two columns 
CI2=zeros(size(CI));
hyp2=hyp;
for i=1:size(CI,2) %the CI matrix has 19 columns
    hyp=hyp2;
    signal=CI(:,i);
    delta=diff(signal);
    f=find(abs(delta)>3); 
    for j=1:length(f)
        %if hyp(f(j),2)==hyp(f(j)+1,2)
            if signal(f(j))<signal(f(j)+1) %if there was an increase
            signal(f(j))=NaN;
            hyp(f(j),:)=NaN;
            else %there was a decrease
              signal(f(j)+1)=NaN;
            hyp(f(j)+1,:)=NaN;  
            end
       % end
    end
%     length(signal)
    signal(signal<2)=NaN;   
    hyp(signal<2,:)=NaN;
%     figure
%     plot(hyp2(:,1),CI(:,i))
%     hold on
%     plot(hyp2(:,1),signal,'r');
%     plot(hyp2(:,1),hyp2(:,2),'g')
    
    
    CI2(1:length(signal),i)=signal;
end
   