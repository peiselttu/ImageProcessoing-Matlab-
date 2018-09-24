
clc;
clear all;
close all;

prompt = 'Enter the file name with extension: ';
 fileName = input(prompt,'s');
 oriImage=imread(fileName);

 % oriImage=imread('Testimage3.tif');
figure
imshow(oriImage);
title('Input Image');

%% binarize the image
bwImage=imbinarize(oriImage);

%to eliminate the little white holes in the black background
bw=bwareaopen(bwImage,30);

% figure
% imshow(bw);
% title('Binary Image')

%% Detect 2 corners to determine the angle of rotation of the image

%detect the upper-left corner
[x_left,y_left]=topLeft(bw);
% detect the bottom left corner
[x_bottom,y_bottom]=bottomLeft(bw);

hold on
plot(x_left,y_left,'ro');
plot(x_bottom,y_bottom,'ro');

% calculate the vertical and horizontal distances between the two corners
w=x_bottom-x_left;
h=y_bottom-y_left;

%get the theta using arc tangent
theta=atand(h/w);

%calculate the distance between the two points to prepare for imrotate()
dis=sqrt((x_left-x_bottom)^2+(y_left-y_bottom)^2);

%% Rotate the image based on the calculated angle

% rotate the image based on if the two points detected are long edge of the
% card or short edge of the card
[r,c]=size(oriImage);
if 1.0*dis/c>0.48
    I=imrotate(oriImage,theta+90,'bilinear','crop'); % Rorate by 'theta + 90' if long edge
    I_bw=imrotate(bw,theta+90,'bilinear','crop'); % Also rotate the binarized image
else
    I=imrotate(oriImage,theta,'bilinear','crop'); % Rorate by 'theta' if short edge
    I_bw=imrotate(bw,theta,'bilinear','crop'); % Also rotate the binarized image
end 

% figure
% imshow(I)
% title('rotated Image')


%% Detection of the 4 corners after rotating the image in order for the cropping

% detect the upper-left corner
[x_left,y_left]=topLeft_r(I_bw);
% detect the bottom left corner
[x_bottom,y_bottom]=bottomLeft_r(I_bw);
% detect the top-right corner
[x_upper,y_upper]=topRight_r(I_bw);
% detect the bottom-right corner
[x_right,y_right]=bottomRight_r(I_bw);

% figure
% imshow(I_bw)
% title('rotated black white image')
% hold on
% plot(x_left,y_left,'ro');
% plot(x_bottom,y_bottom,'ro');
% plot(x_upper,y_upper,'ro');
% plot(x_right,y_right,'ro');

% Crop the image
cropped_im = I(y_upper:y_bottom,x_left:x_right,:);
figure
imshow(cropped_im)
title('Cropped Image')

%% Functions to detect corners

% top left corner detect
function[x_left,y_left]=topLeft(bw)
[h,w]=size(bw);
x_left=0;
y_left=0;
flag_left=0;
for j=1:w
    for i=1:h
        if bw(i,j)==1
            x_left=j;
            y_left=i;
            flag_left=1;
            break
        end
    end
     if flag_left==1
        break
     end
end
end

%bottom corner detect
function [x_bottom,y_bottom]=bottomLeft(bw)
x_bottom=0;
y_bottom=0;
flag_bottom=0;
[h,w]=size(bw);
for i=h:-1:1
    for j=1:w
        if bw(i,j)==1
            x_bottom=j;
            y_bottom=i;
            flag_bottom=1;
            break;
        end
    end
    if flag_bottom==1
        break
    end
end
end

% bottom right corner detect
function[x_right,y_right]=bottomRight_r(bw)
[h,w]=size(bw);
x_right=0;
y_right=0;
flag_right=0;
for j=w:-1:1
    for i=1:h
        if bw(i,j)==1
            x_right=j;
            y_right=i;
            flag_right=1;
            break
        end
    end
     if flag_right==1
        break
     end
end
end


% upper right corner detect
function [x_upper,y_upper]=topRight_r(bw)
x_upper=0;
y_upper=0;
flag_bottom=0;
[h,w]=size(bw);
for i=1:h
    for j=w:-1:1
        if bw(i,j)==1
            x_upper=j;
            y_upper=i;
            flag_bottom=1;
            break;
        end
    end
    if flag_bottom==1
        break
    end
end
end

% left corner detect
function[x_left,y_left]=topLeft_r(bw)
[h,w]=size(bw);
x_left=0;
y_left=0;
flag_left=0;
for j=1:w
    for i=1:h
        if bw(i,j)==1
            x_left=j;
            y_left=i;
            flag_left=1;
            break
        end
    end
     if flag_left==1
        break
     end
end
end

%bottom corner detect
function [x_bottom,y_bottom]=bottomLeft_r(bw)
x_bottom=0;
y_bottom=0;
flag_bottom=0;
[h,w]=size(bw);
for i=h:-1:1
    for j=1:w
        if bw(i,j)==1
            x_bottom=j;
            y_bottom=i;
            flag_bottom=1;
            break;
        end
    end
    if flag_bottom==1
        break
    end
end
end
