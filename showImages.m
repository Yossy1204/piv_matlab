subplot(2,2,3)
imagesc(I1-mean(I1(:)))
title('Image 1 @ ROI')
subplot(2,2,4)
imagesc(I2-mean(I2(:)))
title('Image 2 @ ROI')

img = zeros([size(I1), 2]);
img(:,:,1) = I1;
img(:,:,2) = I2;

figure(2)
imagesc(I2-I1)
colorbar
drawnow