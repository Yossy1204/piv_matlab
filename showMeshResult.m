n_show = 20;

figure(2)
subplot(1,2,1)
imagesc(img(:,:,1))
hold on
scatter(img_set.position(:,2),img_set.position(:,1),'.r')
for i=1:length(img_set.position(:,1))
    col=[0,1,1];
    rectangle('Position',[img_set.position(i,2), img_set.position(i,1), size_window, size_window], 'EdgeColor', col)
end
hold off
subplot(1,2,2)
imagesc(img_set.image(:,:,n_show))
title(['Image Fracetion @ ' num2str(n_show)])
drawnow

figure(3)
imagesc(img(:,:,1))
hold on
rectangle('Position',[img_set.position(n_show,2)-1, img_set.position(n_show,1)-1, size_window, size_window], 'EdgeColor', [1,0,0])
hold off
title('Image Fraction Position')
drawnow
