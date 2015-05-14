% Current image fraction
subplot(1,2,1)
imagesc(img_set.image(:,:,i))
str = ['Image Fraction @' num2str(i)];
title(str)

% Visualization of the calculated coefficient map
subplot(1,2,2)
imagesc(R_map)
colorbar
title('Correlation Map')
drawnow