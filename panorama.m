clear
addpath('./SIFT-liuqk');
disp('Reading Images...');
[images, numImages] = readImages('./images1/');

%f = 682.05069;
f = 1033;
k1 = -0.22892;
k2 = 0.27797;
pad = 500;
images_cyl = cell(1,numImages);

%Calculate cylindrical projections
disp('Calculating cylindrical images...');
for i = 1:numImages
    images_cyl{1,i} = cylindrical_copy(images{1,i}, f, pad);
end
disp('Constructing Mosaic...');
xshift_set = zeros([1,numImages]);
yshift_set = zeros([1,numImages]);
currMosaic = images_cyl{numImages};

im = single(rgb2gray(images_cyl{1,numImages}));
toStitch_sift = sift(im,0,'*');
for i = numImages:-1:2
    toStitch1 = images_cyl{1,i};
    toStitch2 = images_cyl{1,i-1};
    im2 = single(rgb2gray(toStitch2));
    toStitch1_sift = toStitch_sift;
    toStitch2_sift = sift(im2,0,'*');
    [xshift_set(i),yshift_set(i)] = feature_matching(toStitch1,toStitch2,toStitch1_sift,toStitch2_sift);
    toStitch_sift = toStitch2_sift;
end
%stitch first and last images to find final yshift
toStitch1 = images_cyl{1};
toStitch2 = images_cyl{numImages};
im1 = single(rgb2gray(toStitch1));
im2 = single(rgb2gray(toStitch2));
toStitch1_sift = sift(im1,0,'*');
toStitch2_sift = sift(im2,0,'*');
[xshift,yshift] = feature_matching(toStitch1,toStitch2, toStitch1_sift,toStitch2_sift);
diff_y = sum(yshift_set) - yshift;
yshift_set = yshift_set - diff_y/(numImages-1);

totalyshift = 0;
for i = numImages:-1:2
    toStitch1 = images_cyl{1,i};
    toStitch2 = images_cyl{1,i-1};
    totalyshift = totalyshift + yshift_set(i);
    currMosaic = stitch(currMosaic, toStitch2, xshift_set(i), totalyshift);
end
currMosaic = crop(currMosaic);
imwrite(uint8(currMosaic),'./someResults/totaly.jpg');



