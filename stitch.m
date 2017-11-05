function [ newImg ] = stitch( I1, I2, xshift, yshift )
%Stitch Stitches 2 images given an x and y shift.
% 

% ATTEMPTED BUT FAILED
% First match exposures
% I2 = get_exposure_diff(I1, I2, xshift, yshift, pad);

% Feathering weight
xshift = floor(xshift);
yshift = floor(yshift);
newImg = zeros(size(I1,1)+abs(yshift),size(I1,2)+size(I2,2),3);
if yshift >= 0
    newImg(1:size(I1,1),1:size(I1,2),:) = I1;
    newImg(yshift+1:size(I2,1)+yshift,size(I1,2)+1:size(newImg,2),:) = I2;
else
    newImg(1-yshift:size(I1,1)-yshift,1:size(I1,2),:) = I1;
    newImg(1:size(I2,1),size(I1,2)+1:size(newImg,2),:) = I2;
end
%imwrite(newImg, 'catImg.jpg');
count = 0;
for col = (size(I1,2))+1:1:size(newImg,2)
    if col-xshift <= size(I1,2)
        %w = count / double(xshift);
        w = 1;
        newImg(:,col-xshift,:) = floor(w*newImg(:,col,:) + (1-w)*newImg(:,col-xshift,:));
    else
        newImg(:,col-xshift,:) = newImg(:,col,:);
    end
    count = count + 1;
end

col = size(I1,2) - xshift + size(I2,2);
newImg = newImg(:, 1:col,:);

end

