function maskedImage = filterNiels(Image) 

% Convert RGB image to HSV image
height = size(Image, 1);
width =  size(Image, 2);
midheight = round(height/2.0);

maskedImage = Image;

% loop over all rows and columns
%rows
for ii=midheight:height
    %columns
    for jj=1:width
          maskedImage(ii,jj)= 0;
    end
end