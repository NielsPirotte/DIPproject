%% Section 1 Background frame

close all;
clear;
clc;

% create video  object
vid = VideoReader('Wandeling_1b.mp4');

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
E=1;
m=40.0;

%%%%Tuur
aantalFrames = 0;
grafiekX = [];
grafiekY = [];
%%%%

%%Achtergrond
achtergrondFrame = read(vid, 1);
se_tekst = strel('rectangle', [5 5]);
xA = imclose(achtergrondFrame, se_tekst);
xA = imopen(xA, se_tekst);

%figure, imshow(achtergrondFrame)
%xAT = rgb2gray(achtergrondFrame);
%xA = im2double(xAT);
%figure('name', 'gray'), imshow(xA)
%se_tekst = strel('rectangle', [5 5]);
%xA = imclose(achtergrondFrame, se_tekst);
%figure('name', 'filter_tekst'), imshow(xA)
%xA = medfilt2(xA, medf);

%% section 2 Forground frame
%for i=100:no_frames
%figure,
for i = 1:no_frames
    i*100.0/no_frames
    frame = read(vid,i);
    
    %%Plaats hier je verwerking per frame %%
    
    %%Voorgrond
    voorgrondFrame = read(vid, i);
    se_tekst = strel('rectangle', [5 5]);
    xV = imopen(voorgrondFrame, se_tekst);
    %xV = imopen(xV, se_tekst);
    
    %figure('name', 'frame'), imshow(voorgrondFrame)
    %xVT = rgb2gray(voorgrondFrame);
    %xV = im2double(xVT);
    %figure('name', 'xV'), imshow(xV)
    
    %xV = imclose(xV, se_tekst);
    %xV = medfilt2(xV, medf);
    %figure('name', 'voorgrond'), imshow(xV);
    
    
    %%Verschil
    xVerschil = xA - xV;  
    %imshow(xVerschil); 

    % plot the original image, mask and filtered image all in one figure
    %figure('name', 'masked'), imshow(masked);
    fBlack = im2bw(xVerschil, 0.20);
    %figure('name', 'toblack'), imshow(fBlack);
    se_oc = strel('rectangle', [7 15]);
    fo = imopen(fBlack, se_oc);
    fo = imclose(fo, se_oc);
    %figure('name', 'oc'), imshow(fo);
    fo = filterNiels(fo);
    
    %%%
    s = regionprops(fo, {'Centroid', 'BoundingBox'});
    
    imshow(fo);
    
    if numel(s) ~= 0
            aantalFrames = aantalFrames +1;
        
            breedteX = s(1).BoundingBox(3);
            PosX = s(1).BoundingBox(1)+breedteX;
            if breedteX < 40
                continue;
            end
            
            if PosX >= vidWidth 
                   break;
            end
        
            
            mid = s(1).BoundingBox(2) + (s(1).BoundingBox(4)/2);
            grafiekX1 = [grafiekX; s(1).BoundingBox(1)];
            grafiekY1 = [grafiekY; mid];
            grafiekX = [grafiekX; s(1).Centroid(1)];
            grafiekY = [grafiekY; s(1).Centroid(2)];
             hold on
             plot(s(1).Centroid(1), s(1).Centroid(2), 'r*')
             rec = rectangle('Position', [s(1).BoundingBox(1), s(1).BoundingBox(2), s(1).BoundingBox(3), s(1).BoundingBox(4)], 'EdgeColor', 'r', 'LineWidth', 2);             
             hold off
    end
    %%
    
    %xVerschil =1./(1+(m./(xVerschil+eps)).^E);
    %figure('name', 'contrast'), imshow(xVerschil);

    
    %%section 3 Make uniform
    %%Uniform maken
    %xVerschil = histeq(xVerschil, 1000);
    %figure('name', 'histeq'), imshow(xVerschil)
    
    %se_oc = strel('square', 10);
    %xVerschil = imopen(xVerschil, se_oc);
    %xVerschil = imclose(xVerschil, se_oc);
    %figure('name', 'open en close'), imshow(xVerschil)
    
    %% 

    %fBlack = im2bw(xVerschil, 0.19);
    
    %fBlack = xVerschil > 0.9038;
    %fBlack = bwmorph(fBlack, 'clean');
    %imshow(fBlack);
    %figure('name', 'to black'), imshow(fBlack)
    
    %Opening by reconstruction
    %fe=imerode(fBlack,ones(80,30));
    %fBlack1=imreconstruct(fe,fBlack);
    
    %figure('name', 'reconstruct'), imshow(fBlack1)
    %imshow(fBlack1)
    %%figure, imshow(xVerschil)
    %%figure, imhist(xVerschil)
    %%Opening/closing
    %se = strel('disk', 10);
    %se_tekst = strel('rectangle', [25, 15]);
    %figure('name', 'opening'), imshow(fBlack)
    %fo = imopen(fBlack,se);
    %fo = imclose(fBlack, strel('rectangle', [20 8]));
    %fo = imclose(fo, se);
    %imshow(fo)
    
    %strategie:
    %Detecteer per frame of er een object verschijnt
    %tel dan hoeveel frames en vermedigvuldig met de framerate
    
    %countFrames=0 ;
    
end

%grafiekX
%grafiekY
speed = ((lengthWalk*framerate)/(aantalFrames))*3.6

grafiekY = smooth(grafiekY);
figure, plot(grafiekX, grafiekY)
figure, plot(grafiekX1, grafiekY1)

%bereken wandelsnelheid
%speed = lengthWalk/(countFrames * framerate);


