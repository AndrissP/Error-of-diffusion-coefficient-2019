function [ Mx, My, Radii ] = Find_coordinate ( image )
% To use with Find_coord. Finds the coordinate of the center of the circle.
% By Artis Brasovs

[~,~, numberOfColorChannels] = size(image);
if numberOfColorChannels > 1
    % It's a true color RGB image.  We need to convert to gray scale.
    araw = rgb2gray(image);
else
    % It's already gray scale.  No need to convert.
    araw = image;
end
awien=wiener2(wiener2(araw));
%imshow(awien, [])

croper=0.8; % Skatot. uz bilþu kval. (pçc 1. attçla var novçrtçt) (0.8)
numPix=[];
while length(numPix)<1
    %[junk, threshold] = edge(awien,'canny');  
    aedge=edge(awien, 'canny', croper);
    se90 = strel('line', 5, 90);
    se0 = strel('line', 5, 0);
    adil = imdilate(aedge, [se90 se0]);
    needle = imfill(adil, 'holes');

    %find biggest-----------------------------------------------------------
    CC=bwconncomp(needle, 8);
    needle=false(size(needle));
    numPix=cellfun(@numel, CC.PixelIdxList);
    croper=croper-0.05;
end
[~, idx]=max(numPix);
needle(CC.PixelIdxList{idx})=true;

%imshow(needle);

d_rect_x=0;d_rect_y=0;

props=regionprops(needle,'Centroid','MajorAxisLength','MinorAxisLength','Area'); %,'Orientation'
Mx=props.Centroid(1);
My=props.Centroid(2);
Radii=mean([props.MajorAxisLength props.MinorAxisLength]);

%Length(n)=props.MajorAxisLength-Length_Correction;
%Width(n)=props.MinorAxisLength/Width_Correction;
%angle(n)=-props.Orientation;


Mx=Mx+d_rect_x;
My=My+d_rect_y;


end

