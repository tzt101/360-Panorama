function [xshift, yshift] = feature_matching( I1, I2, im1_sift, im2_sift )
% THIS FUNCTION IS CURRENTLY NOT WORKING
%feature_matching Matches features in two images
%   Using the vlfeat library, this function takes two images and
%   1. Calculates features in each image.
%   2. Matches the features detected in each image
%   3. Runs the feature points through RANSAC to detect outliers
%       - Pick 4 random feature points from each image
%       - Estimate homography
%       - Homography estimation is described here: http://6.869.csail.mit.edu/fa12/lectures/lecture13ransac/lecture13ransac.pdf
%       - See how good the homography is
%   4. Calculate the xshift and yshift from the best homography found.


im1 = single(rgb2gray(I1));
im2 = single(rgb2gray(I2));

% Compute features for each image
%disp('Calculate SIFT feature...');
%[fa, da] = vl_sift(im1) ;
%[fb, db] = vl_sift(im2) ;
%[desa, loca] = getFeatures(im1);
%[desb, locb] = getFeatures(im2);
%im1_sift = sift(im1,0,'*');
%im2_sift = sift(im2,0,'*');
% Check for matches in the features detected. Matches is a 2*n vector.
% Where (1,i) is the column index of the feature in fa that was match to 
% the feature in fb whose column index is (2,i) in matches. 
disp('Calculate Matches using descriptors from SIFT...');
%[matches] = match(desa, desb);
[X1,X2] = sift_match(im1_sift,im2_sift);
numMatches = size(X1,2);

   
%% RANSAC
% Steps:
per_num = max(5, floor(0.1*numMatches));
width1 = size(im1,2);

for iter=1:100
    xshift_sum = 0;
    yshift_sum = 0;
    cols = randperm(numMatches, per_num);
    x1 = X1(:,cols);
    x2 = X2(:,cols);
    shift1 = x2 - x1;
    shift_per_y = shift1(2,:);
    shift_per_x = shift1(1,:) + width1;
    meanxshift = mean(shift_per_x);
    meanyshift = mean(shift_per_y);
    %others
    shift2 = X2 - X1;
    shift_all_x = shift2(1,:) + width1;
    shift_all_y = shift2(2,:);
    ok_num = 0;
    for i=1:numMatches
        theta_x = abs(meanxshift-shift_all_x(i));
        theta_y = abs(meanyshift-shift_all_y(i));
        if theta_x < 10 && theta_y < 5
            ok_num = ok_num + 1;
            xshift_sum = xshift_sum + shift_all_x(i);
            yshift_sum = yshift_sum + shift_all_y(i);  
        end
    end
    if ok_num > 0.9*numMatches
        xshift = xshift_sum/ok_num;
        yshift = yshift_sum/ok_num;
        iter
        break;
    end
    if iter==100
        xshift = sum(shift_all_x)/numMatches;
        yshift = sum(shift_all_y)/numMatches;
    end
end
 

end

