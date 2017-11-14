function maskedImage = filterNiels(Image, cutoff) 

% Convert RGB image to HSV image
height = size(Image, 1);
width =  size(Image, 2);
midheight = round(height/2.0);

if cutoff == 0
   cut = midheight;
else
   cut = cutoff;
end

maskedImage = Image;

% loop over all rows and columns
%rows
for ii=cut:height
    %columns
    for jj=1:width
          maskedImage(ii,jj)= 0;
    end
end