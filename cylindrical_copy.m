 function [ I_cylindrical ] = cylindrical_copy( I, f, pad )
% cylindrical - Calculates the cylindrical coordinates of an image.
%   Takes an image RGB values at coordinates X and Y and caclculates the
%   cylindrical coordinates of those RGB values. 
%   
% Input Arguments: I = Image, f = focal length of camera.

width = size(I,2);
height = size(I,1);


width_cyl = 2*f*sin(atan(width/(2*f)));
unwrapped = zeros(height, floor(width_cyl), 3);
%unwrapped = zeros(floor(f), floor(f), 3);
x_cyl_center = floor(width_cyl/2);
y_cyl_center = floor(height/2);


% for i = 1:width
%     for j = 1:height
%         curr_x = i-x_center; %Start at -x_center go to +x_center
%         curr_y = j-y_center; %Start at -y_center go to +y_center
% 
%         theta = asin(curr_x/(sqrt(curr_x*curr_x + f*f)));
%         %theta = curr_x/f;
%         
%         h = curr_y/(sqrt(curr_x*curr_x + f*f));
%         %h = curr_y/f;
% 
%         %Find the corresponding x and y coordinate in the unwrapped
%         %cylinder
%         x_cyl = round(f*theta + x_center);
%         y_cyl = round(f*h + y_center);
%         %x_cyl = round(f*tan(theta) + x_center);
%         %y_cyl = round(f*h/cos(theta) + y_center);
%         unwrapped(y_cyl,x_cyl,:) = I(j,i,:);
%     end
% end
pad = 1;% pad the original image to obtain a better projected image.
if length(size(I)) == 3
    image_pad = zeros(height+2*pad, width+2*pad,3);
else
    image_pad = zeros(height+2*pad, width+2*pad,3);
end
image_pad(pad+1:pad+height, pad+1:pad+width,:) = I;

x_center = floor(width/2);
y_center = floor(height/2);


for i=1:width_cyl
    for j=1:height
        curr_x_cyl = i-x_cyl_center;
        curr_y_cyl = j-y_cyl_center;
        theta = asin(curr_x_cyl/f);
        h = curr_y_cyl/f;
        x = f*tan(theta) + x_center;
        y = f*h/cos(theta) + y_center;
%         if x >=1 && y >= 1 && x<width && y<height
%         unwrapped(j,i,:) = I(round(y),round(x),:);
%         end
        if x >= 0 && x <= width+1 && y >= 0 && y <= height+1
           x1 = floor(x);
           x2 = ceil(x);
           y1 = floor(y);
           y2 = ceil(y);
           if x1 ~= x && y1~= y
              pixel11 = image_pad(y1+pad,x1+pad,:) * ((x2 -x)*(y2-y)) / ((x2-x1)*(y2-y1));
              pixel21 = image_pad(y1+pad,x2+pad,:) * ((x -x1)*(y2-y)) / ((x2-x1)*(y2-y1));
              pixel12 = image_pad(y2+pad,x1+pad,:) * ((x2 -x)*(y-y1)) / ((x2-x1)*(y2-y1));
              pixel22 = image_pad(y2+pad,x2+pad,:) * ((x -x1)*(y-y1)) / ((x2-x1)*(y2-y1));
              unwrapped(j,i,:) = pixel11+ pixel21 + pixel12 + pixel22;
           elseif x1 == x && y1 ~= y
               unwrapped(j,i,:) = image_pad(y1+pad,x1+pad,:) *(y2-y) / (y2-y1) + image_pad(y2+pad,x1+pad,:) * (y-y1) / (y2-y1);
           elseif y1 == y && x1 ~= x
               unwrapped(j,i,:) = image_pad(y1+pad,x1+pad,:) * (x2 -x) / (x2-x1) + image_pad(y1+pad,x2+pad,:) * (x -x1) / (x2-x1);
           else
               unwrapped(j,i,:) = image_pad(y1+pad,x1+pad,:);
           end
        end
    end
end
I_cylindrical = uint8(unwrapped);
%pad = zeros(padheight, size(I_cylindrical,2), size(I_cylindrical,3));
%I_cylindrical = [pad; I_cylindrical; pad];













