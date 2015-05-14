
imagesc(img(:,:,1));
hold on
scale = 1;
quiver(img_set.position(:,2)+size_window/2,img_set.position(:,1)+size_window/2,velocity(:,2),velocity(:,1),vector_scale,'Color',[0,1,1],'LineWidth',1)
hold off
title('PIV result without Validation')
