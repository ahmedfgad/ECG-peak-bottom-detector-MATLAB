function [detectedPeaks, detectedBottoms] = peakFinder(signal)
sig = imread(signal);
bSig = im2bw(sig);
imwrite(bSig,'npSignal.png');
bSig = imread('npSignal.png');
info = imfinfo('npSignal.png');
figure('name','Original Binary Signal');
imshow(bSig);

%% Step 1: "Crop the unwanted portions at the beginning of the signal by some means of thresholds"
croppedBSig=bSig;
sigMean=0;
for wid=1:info.Width
    sigMean=mean(mean(bSig(:,wid:wid)));
    if sigMean >= .9
        croppedBSig(:,wid:wid) = 1;
    end
end

%% Step 2: "Extract portions of the signal that maintains information from the original signal to make sure that 0% loss of info. occured"
wid=1;
while wid<=info.Width-5
    sigMean=mean(mean(croppedBSig(:,wid:wid)));
    if sigMean ~= 1
        croppedBSig(:,wid-5:wid+5) = bSig(:,wid-5:wid+5);
        wid=wid+6;
    else
        wid=wid+1;
    end
end
figure('Name','Signal after cropping "unwanted portions" and finding the "peaks" and "buttoms"');imshow(croppedBSig);
hold on;
imwrite(croppedBSig,'croppedBSignal.png');

%% Step 3:"Finding the beginning and the end of each region"
croppedBSig=imread('croppedBSignal.png');
info = imfinfo('croppedBSignal.png');
detectedPortions = []; %This array holds the start and end of each portion that contains data that we`ll analyze in the next step.
numberOfPortions = 0;
wid=1;
nonOneMeanFound=0; %This flag is used to detect if a beggining or an end is found.
while wid<=info.Width
    sigMean=mean(mean(croppedBSig(:,wid:wid)));
    if sigMean~=1 && nonOneMeanFound==0
        numberOfPortions=numberOfPortions+1;
        detectedPortions(numberOfPortions)=wid;%Holds the "beginning" of the region.
        nonOneMeanFound=1;%The flag is raised saying that a new region is found.
    end
    if nonOneMeanFound==1
        sigMean=mean(mean(croppedBSig(:,wid:wid)));
        if sigMean==1
            numberOfPortions=numberOfPortions+1;
            detectedPortions(numberOfPortions)=wid-1;%Holds the "end" of the region.
            nonOneMeanFound=0;%The flag now is down saying that the end of the region is found.
        end
    end
    wid=wid+1;%Increment the loop variable.
end
%% Step 4:"Scan each portion for the peaks and return it into an array"
findPeaks=1;
peakY=0;
peakX=0;
detectedPeaks=[];%Creating an array that holds the vertices of the peaks detected.
%This array holds the Y of the peak followed by its X.
while findPeaks<=numberOfPortions-1
    portionBeingProcessed=croppedBSig(:,detectedPortions(findPeaks):detectedPortions(findPeaks+1));
    %Finding the black pixel in the white row.
    for hit=1:size(portionBeingProcessed,1)%This loop is used to find the "row(Y)" in which the peak lies.
        signalMean=mean(mean(portionBeingProcessed(hit:hit,:)));
        if signalMean~=1
            rowHasPeak=portionBeingProcessed(hit:hit,:);%This array contains a row of values and the black one is the peak we want.
            peakY=hit;
            detectedPeaks(findPeaks)=peakY;
            break
        end
    end
    
    for ind=1:size(rowHasPeak,2)%This loop is used to find the "column(X)" in which the peak lies.
        if rowHasPeak(ind)==0
            peakX=ind+detectedPortions(findPeaks);
            detectedPeaks(findPeaks+1)=peakX;
            break;
        end
    end
    %Now, drawing a rectangle over the peak to highlight it.
    BoundingBox=uint16([peakX-1,peakY-1,2,2]);
    rectangle('Position',BoundingBox,'LineWidth',2,'LineStyle','-','EdgeColor','r');
    findPeaks=findPeaks+2;
end

%% Step 5:"Scan each portion for the bottoms and return it into an array"
findBottoms=1;
bottomY=0;
bottomX=0;
detectedBottoms=[];%Creating an array that holds the vertices of the bottoms detected.
%This array holds the Y of the bottom followed by its X.
while findBottoms<=numberOfPortions-1
    portionBeingProcessed=croppedBSig(:,detectedPortions(findBottoms):detectedPortions(findBottoms+1));
    %Finding the black pixel in the white row.
    for hit=size(portionBeingProcessed,1):-1:1%This loop is used to find the "row(Y)" in which the bottom lies.
        signalMean=mean(mean(portionBeingProcessed(hit:hit,:)));
        if signalMean~=1
            rowHasBottom=portionBeingProcessed(hit:hit,:);%This array contains a row of values and the black one is the bottom we want.
            bottomY=hit;
            detectedBottoms(findBottoms)=bottomY;
            break
        end
    end
    
    for ind=size(rowHasBottom,2):-1:1%This loop is used to find the "column(X)" in which the bottom lies.
        if rowHasBottom(ind)==0
            bottomX=ind+detectedPortions(findBottoms);
            detectedBottoms(findBottoms+1)=bottomX;
            break;
        end
    end
    %Now, drawing a rectangle over the bottom to highlight it.
    BoundingBox=uint16([bottomX-1,bottomY-1,2,2]);
    rectangle('Position',BoundingBox,'LineWidth',2,'LineStyle','-','EdgeColor','g');
    findBottoms=findBottoms+2;
end

figure('Name','Portions Detected');
plotVar=1;
findBottoms=1;
while findBottoms<=numberOfPortions-1%Showing the cropped regions independently.
    portionBeingProcessed=croppedBSig(:,detectedPortions(findBottoms):detectedPortions(findBottoms+1));
    if plotVar<=numberOfPortions/2
        subplot(1,numberOfPortions/2,plotVar);
        imshow(portionBeingProcessed);
    end
    plotVar=plotVar+1;
    findBottoms=findBottoms+2;
end

%% This code also shows the cropped regions independently but using the peaks rather than the bottoms.

% figure('Name','Portions Detected');
% plotVar=1;
% findPeaks=1;
% while findPeaks<=numberOfPortions-1%Showing the cropped regions independently.
%     portionBeingProcessed=croppedBSig(:,detectedPortions(findPeaks):detectedPortions(findPeaks+1));
%     if plotVar<=numberOfPortions/2
%         subplot(1,numberOfPortions/2,plotVar);
%         imshow(portionBeingProcessed);
%     end
%     plotVar=plotVar+1;
%     findPeaks=findPeaks+2;
% end
figure(2);%Set the figure that shows the peaks and bottoms the active one.

%%
hold off;
%Now I`ll delete the pre-written images.
delete('npSignal.png');
delete('croppedBSignal.png');

