%%
res=a./mean(a(150:200))-1; % demean, change index range if necessary
time = (1:600)'*0.05; % time stamp, change if necessary
[pks,locs,~,~] = findpeaks(res,'MinPeakDistance',100,'NPeaks',3,'SortStr','descend','Annotate','extents'); % find 3 peaks
findpeaks(res,'MinPeakDistance',100,'NPeaks',3,'SortStr','descend','Annotate','extents');legend('off');
zcross = find(diff(res>0)==1)+1; % find zero-crossig index

%% % run multiple times may yield better result
ft = fittype( '1-exp(-k*(x-t))', 'independent', 'x', 'dependent', 'y' ); % fitting equation
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
figure,plot(time,res);hold on;

Ti = zeros(3,1);rsq = zeros(3,1);
warning('off','all')

for i=1:3
    idx = zcross(find((zcross-locs(i))<0,1,'last')); % find the nearest zero-crossing point to the peak
    x = time(idx:locs(i));
    y = res(idx:locs(i))./pks(i);

    % Fit model to data.
    [fitobject, gof] = fit(x, y, ft, opts);
    Ti(i) = fitobject.t; rsq(i) = gof.rsquare;
    
    plot(fitobject,x,y.*pks(i));legend('off');
end
hold off;

warning('on','all')
result = sortrows([Ti rsq],1) % sort timing (peaks are sorted by amplitude, not location)
