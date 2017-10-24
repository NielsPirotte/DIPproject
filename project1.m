%% Section 1 Background frame

close all;
clear;
clc;

% create video  object
vid = VideoReader('Wandeling_1a.mp4');

%Get properties from video
framerate = vid.framerate;
duration = vid.duration;
no_frames = vid.NumberOfFrames;
vidHeight = vid.Height;
vidWidth = vid.Width;

%get video frames

%parameters
lengthWalk = 3.15; %lengte van de wandeling
medf = [3 3];

%%Achtergrond
achtergrondFrame = read(vid, 1);
%figure, imshow(achtergrondFrame)
xAT = rgb2gray(achtergrondFrame);
xA = im2double(xAT);
%figure('name', 'gray'), imshow(xA)
se_tekst = strel('rectangle', [5 5]);
xA = imclose(xA, se_tekst);
%figure('name', 'filter_tekst'), imshow(xA)
%imopen
xA = medfilt2(xA, medf);

%% section 2 Forground frame
%for i=100:no_frames
for i = 180:180
    frame = read(vid,i);
    
    %%Plaats hier je verwerking per frame %%
    
    %%Voorgrond
    voorgrondFrame = read(vid, i);
    %figure('name', 'frame'), imshow(voorgrondFrame)
    xVT = rgb2gray(voorgrondFrame);
    xV = im2double(xVT);
    
    xV = imclose(xV, se_tekst);
    
    xV = medfilt2(xV, medf);
    %%Verschil
    xVerschil = xA - xV;
 
    figure('name', 'verschil'), imshow(xVerschil)
    
    %%section 3 Make uniform
    %%Uniform maken
    xVerschil = histeq(xVerschil, 1000);
    figure('name', 'histeq'), imshow(xVerschil)
    
    se_oc = strel('square', 10);
    xVerschil = imopen(xVerschil, se_oc);
    xVerschil = imclose(xVerschil, se_oc);
    figure('name', 'open en close'), imshow(xVerschil)
    
    %% 

    %fBlack = xVerschil> 0.22;
    fBlack = xVerschil > 0.9038;
    %fBlack = bwmorph(fBlack, 'clean');
    
    figure('name', 'to black'), imshow(fBlack)
    
    %Opening by reconstruction
    fe=imerode(fBlack,ones(80,30));
    fBlack1=imreconstruct(fe,fBlack);
    
    %figure('name', 'reconstruct'), imshow(fBlack1)
    imshow(fBlack1)
    %%figure, imshow(xVerschil)
    %%figure, imhist(xVerschil)
    %%Opening/closing
    se = strel('disk', 10);
    %se_tekst = strel('rectangle', [25, 15]);
    %figure('name', 'opening'), imshow(fBlack)
    fo = imopen(fBlack1,se);
    %imshow(fo)
    
    %strategie:
    %Detecteer per frame of er een object verschijnt
    %tel dan hoeveel frames en vermedigvuldig met de framerate
    
    countFrames=0 ;
    
end

%bereken wandelsnelheid
%speed = lengthWalk/(countFrames * framerate);



