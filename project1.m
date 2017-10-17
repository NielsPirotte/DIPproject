close all;
clear;
clc;

% create video  object
vid = VideoReader('wandeling_1a.mp4');

%Get properties from video
framerate = vid.framerate;
duration = vid.duration;
no_frames = vid.NumberOfFrames;
vidHeight = vid.Height;
vidWidth = vid.Width;

%get video frames

%parameters
lengthWalk = 3.15; %lengte van de wandeling

%%Achtergrond
achtergrondFrame = read(vid, 1);
figure, imshow(achtergrondFrame)
xAT = rgb2gray(achtergrondFrame);
xA = im2double(xAT);

for i=135:160
%%Voorgrond
voorgrondFrame = read(vid, i);
%%figure, imshow(voorgrondFrame)
xVT = rgb2gray(voorgrondFrame);
xV = im2double(xVT);

%%Verschil
xVerschil = xA - xV;
fBlack = xVerschil>0.2;
%%figure, imshow(xVerschil)
%%figure, imhist(xVerschil)
%%figure, imshow(fBlack)
%%Opening/closing
se = strel('disk', 20);
fo = imopen(fBlack,se);
imshow(fo)
end


for i=1:no_frames
    frame = read(vid,i);
    
    %% Plaats hier je verwerking per frame %%
    
    %strategie:
    %Detecteer per frame of er een object verschijnt
    %tel dan hoeveel frames en vermedigvuldig met de framerate
    
    countFrames=0 ;
    
end

%bereken wandelsnelheid
%speed = lengthWalk/(countFrames * framerate);



