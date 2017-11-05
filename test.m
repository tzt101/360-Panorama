clear
addpath('./sw-sift-master');
addpath('./SIFT-liuqk');
disp('Reading Images...');
[images, numImages] = readImages('./images1/');

load('./someResults/images1/images.mat');
load('./someResults/images1/images_cyl.mat');
load('./someResults/images1/xshift_set.mat');
load('./someResults/images1/yshift_set.mat');
currMosaic = images_cyl{numImages};
totalyshift = 0;
for i = numImages:-1:2
    toStitch1 = images_cyl{1,i};
    toStitch2 = images_cyl{1,i-1};
    totalyshift = totalyshift + yshift_set(i);
    currMosaic = stitch(currMosaic, toStitch2, xshift_set(i), totalyshift);
end
%imshow(uint8(currMosaic));
%currMosaic = crop(currMosaic);
imwrite(uint8(currMosaic),'./someResults/images1/final.jpg');