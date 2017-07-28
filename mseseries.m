function values=mseseries(signal,fs)
% for a given signal, computes the time series of 
% the mse values (first 5), on nonoverlapped windows of 30 s samples each
% input--> signal, column sampled at fs
% output --> values, matrix of length(signal)/(fs*30) rows and 10 columns
values=zeros(floor(length(signal)/(fs*30)),5);
k=1;
for i=1:fs*30:length(signal)-(fs*30-1)
    win=signal(i:i+(fs*30-1));
    y=msentropy(win,[],[],[],[],[],[],[],5,[],[]);
    values(k,:)=y;
    k=k+1;
end
    
    