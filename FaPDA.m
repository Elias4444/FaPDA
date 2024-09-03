%% Threshold calculation

clc, clear all, close all %% Removes system variables and allows the program to start

cd 'C:\Users\warri\Dropbox\' %% Identify the address where the videos to be used are located

video_baseline=VideoReader('R1transA.mp4');%% reading the video to be used of baseline
video_transection=VideoReader('R1transA.mp4');%% reading the video to be used of transection day 1
   N= video_baseline.NumberOfFrames;%% number of frames in baseline video
   n= video_transection.NumberOfFrames;%% number of frames in transction video

load('coordinates.mat')%% loading of anterior and middle facial region coordinates
HOGs=[]; %Create a new variable
HOGs2=[];%Create a new variable
for loop=1:N %% loop for extract HOGs for video
   image=read(video_baseline,loop);%% Extract frame to frame from the video
   imageanterior=imcrop(image, coordenadas(1,:));%% image cut of the anterior area of ​​the face
   imagemiddle=imcrop(image, coordenadas(1,:));%% image cut of the middle area of ​​the face 
   imageanteriorgray= rgb2gray(croppedImg);%% transform image from RGB to grayscale
   imagemiddlegray= rgb2gray(croppedImg);%% transform image from RGB to grayscale

   [featureVector,hogVisualization] = extractHOGFeatures(imageanteriorgray, 'CellSize', [32 32],'BlockSize',[1 1] ,'NumBins',8); %% Extract HOGs fetures from cut image of anterior area
   [featureVector2,hogVisualization2] = extractHOGFeatures(imagemiddlegray, 'CellSize', [32 32],'BlockSize',[1 1] ,'NumBins',8);%% Extract HOGs fetures from cut image of middle area

    HOGs=[HOGs;featureVector];% Save HOGs features in variable HOGs
    HOGs2=[HOGs2;featureVector2];%Save HOGs features in variable HOGs2

end

for loop=1:length(HOGs)% loop to obtain differences between frames
    difference(loop)=HOGs(1)-HOGs(loop)%Creat a variable with differences between frame 1 and all the frames in anterior area of baseline video
    difference2(loop)=HOGs2(1)-HOGs2(loop)%Creat a variable with differences between frame 1 and all the frames in middle area of baseline video
end

HOGs=[]; %Create a new variable
HOGs2=[];%Create a new variable
for loop=1:N %% loop for extract HOGs for video
   image=read(video_transection,loop);%% Extract frame to frame from the video
   imageanterior=imcrop(image, coordenadas(1,:));%% image cut of the anterior area of ​​the face
   imagemiddle=imcrop(image, coordenadas(1,:));%% image cut of the middle area of ​​the face 
   imageanteriorgray= rgb2gray(croppedImg);%% transform image from RGB to grayscale
   imagemiddlegray= rgb2gray(croppedImg);%% transform image from RGB to grayscale

   [featureVector,hogVisualization] = extractHOGFeatures(imageanteriorgray, 'CellSize', [32 32],'BlockSize',[1 1] ,'NumBins',8); %% Extract HOGs fetures from cut image of anterior area
   [featureVector2,hogVisualization2] = extractHOGFeatures(imagemiddlegray, 'CellSize', [32 32],'BlockSize',[1 1] ,'NumBins',8);%% Extract HOGs fetures from cut image of middle area

    HOGs=[HOGs;featureVector];% Save HOGs features in variable HOGs
    HOGs2=[HOGs2;featureVector2];%Save HOGs features in variable HOGs2

end

for loop=1:length(HOGs)% loop to obtain differences between frames
    difference3(loop)=HOGs(1)-HOGs(loop)%Creat a variable with differences between frame 1 and all the frames in anterior area of transection video
    difference4(loop)=HOGs2(1)-HOGs2(loop)%Creat a variable with differences between frame 1 and all the frames in middle area of transection video
end



thersholdanterior=(mean(difference)+mean(difference3))./2% Creat a thershold of anterior area
thersholdmiddle=(mean(difference2)+mean(difference4))./2% Creat a thershold of middle area

%% Use FaPDA: Facial paralysis detection algorithm applied in mice
clc, clear all, close all %% Removes system variables and allows the program to start

cd 'C:\Users\warri\Dropbox\' %% Identify the address where the videos to be used are located

for loop=1:23 %% Loop with all the evaluated videos
    video=VideoReader(['R1trans' num2str(loop) '.mp4']);%% reading the video to be used
HOGs=[]; %Create a new variable
HOGs2=[];%Create a new variable
for loop2=1:N %% loop for extract HOGs for video
   image=read(video,loop2);%% Extract frame to frame from the video
   imageanterior=imcrop(image, coordenadas(1,:));%% image cut of the anterior area of ​​the face
   imagemiddle=imcrop(image, coordenadas(1,:));%% image cut of the middle area of ​​the face 
   imageanteriorgray= rgb2gray(croppedImg);%% transform image from RGB to grayscale
   imagemiddlegray= rgb2gray(croppedImg);%% transform image from RGB to grayscale

   [featureVector,hogVisualization] = extractHOGFeatures(imageanteriorgray, 'CellSize', [32 32],'BlockSize',[1 1] ,'NumBins',8); %% Extract HOGs fetures from cut image of anterior area
   [featureVector2,hogVisualization2] = extractHOGFeatures(imagemiddlegray, 'CellSize', [32 32],'BlockSize',[1 1] ,'NumBins',8);%% Extract HOGs fetures from cut image of middle area

    HOGs=[HOGs;featureVector];% Save HOGs features in variable HOGs
    HOGs2=[HOGs2;featureVector2];%Save HOGs features in variable HOGs2

end
for loop3=1:length(HOGs)% loop to obtain differences between frames
    difference1=HOGs(1)-HOGs(loop3)%Creat a variable with differences between frame 1 and all the frames in anterior area of video
    difference2=HOGs2(1)-HOGs2(loop3)%Creat a variable with differences between frame 1 and all the frames in middle area of video
if difference1<thersholdanterior %conditional to detect frames with values under the thershold
    identityanterior(loop3)=1% frame without movement
else
    identityanterior(loop3)=0% frame with movement    
end
if difference1<thersholdanterior %conditional to detect frames with values under the thershold
    identitymiddle(loop3)=1% frame without movement
else
    identitymiddle(loop3)=0% frame with movement    
end
end
if length(find(identityanterior==1))>(95*N)/100 & length(find(identitymiddle==1))>(95*N)/100 %Detection conditional 
    detection(loop)=1%If 95% of the frames are without movement, the system ends up in paralysis.
else
    detection(loop)=0%If 95% of the frames are without movement, the system ends up in without paralysis
end
end