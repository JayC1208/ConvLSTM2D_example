% v2: use 470 APs

clear all;
close all;
%% seed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seedVal = 3;
rng(seedVal)
%% dataset parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
foldername = "0_DeepLearningData";
mkdir(foldername);
%% APs_dataset parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load('APs_dataset.mat')
S = load('APs_dataset');
AP_num = 470;
AP= ["ap184016", "ap184192", "ap185166", "ap184194", "ap184145", "ap185165", "ap184193","ap184014"];
APloc = [1,1;1,2;2,1;1,3;2,2;2,3;1,4;2,4];
startDate = '05-Jan-2019';
endDate = '09-Feb-2019';
formatIn = 'dd-mmm-yyyy';

startDateNum = datenum(startDate,formatIn);
endDateNum = datenum(endDate,formatIn);

APMap= zeros(2,4);
trafficMap = zeros(5041,2,4);
trafficMapwo= zeros(5041,2,4);
for t=1:length(AP)
    TrafficValues = double(diff(S.(matlab.lang.makeValidName(AP(1,t))).txbytes(1:end)));
    TrafficValues = transpose(TrafficValues);
    TrafficDate = S.(matlab.lang.makeValidName(AP(1,t))).date(2:end);
    TrafficDate = transpose(TrafficDate);
    lowerIdx = startDateNum < TrafficDate;
    higherIdx = TrafficDate < endDateNum;
    Idx = lowerIdx.*higherIdx;
    rmvIdx = find(Idx==0);
    rmvIdx(2473) = [];
    TrafficDate(rmvIdx) = [];
    TrafficValues(rmvIdx) = [];
    
%     y = smooth(TrafficDate,TrafficValues,0.1,'rloess');
%     y = smooth(TrafficDate,TrafficValues);
    y = medfilt1(TrafficValues,8);
    figure(1)
    clf
    hold on
    plot(y,'ko-')
    plot(TrafficValues,'r-')
    thisAPloc = APloc(t,:);
    thisAPX = thisAPloc(1);
    thisAPY =  thisAPloc(2);
    trafficMap(:,thisAPX,thisAPY) = y;
    trafficMapwo(:,thisAPX,thisAPY) = TrafficValues;
end
trafficMapNorm = normalize(trafficMap,'range');
trafficMapNormWO = normalize(trafficMapwo,'range');
save(foldername+'/data_map3.mat','trafficMap','trafficMapwo','trafficMapNorm','trafficMapNormWO')

for idx=4500:5040
    figure(3)
    thisMap = trafficMapNorm(idx,:,:);
    thisMap = reshape(thisMap,2,4);
    h = heatmap(thisMap,'CellLabelColor','none','Colormap',jet);
    h.caxis([0,1]);
%     cData = feval("jet",11);
%     cData = cData(2:end,:);
%     h.Colormap = colormap(cData);
    title("time "+num2str(idx))
    grid on
    h.NodeChildren(3).YDir = 'normal';
    drawnow
%     saveas(figure(3), figurefolder+"/trafficMap_china_"+num2str(i)+".png");
    frame = getframe(3);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);
    if idx==4500
        imwrite(imind, cm, foldername+'/smooth_norm2.gif','gif','Loopcount',1);
    else
        imwrite(imind, cm, foldername+'/smooth_norm2.gif','gif','WriteMode','append');
    end
    
end
