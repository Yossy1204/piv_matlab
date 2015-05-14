clear all; close all; clc

%% Parameters %%%%-----------------------------
pixcel2length = 0.839;
size_window = 20;
% threshold = 0.04;
dt = 33.3*10^-3;%[sec]
shift = 20;
overlap = 0.5;
val_scale = 2.;
val_epsilon = 0.1;
vector_scale = 1.0;
N_iteration = 2;

%% Read Images & Preprocess %%%%-----------------------------
disp('1. Load Images.')

str = 'image/1.tif';
% img1 = im2bw(imread(str),threshold);
img1 = double(imread(str))/255.;

str = 'image/2.tif';
% img2 = im2bw(imread(str),threshold);
img2 = double(imread(str))/255.;

figure(1)
subplot(2,2,1)
imagesc(img1)
title('Image 1')
drawnow

subplot(2,2,2)
imagesc(img2)
title('Image 2')
drawnow

disp('     finish.')



%% Interactive ROI Settings--------------------------------------
disp('2. Set ROI.')

subplot(2,2,1)
[I1,rect] = imcrop;
% img_ROI
subplot(2,2,1)
[I2] = imcrop(img2, rect);

% Visulize the ROI of our PIV
showImages

disp('     finish.')



%%  Meshing images %%%%-------------------------------------------
disp('3. Image Meshing.')
pause

sz = size(img(:,:,1));
x = (shift+1):round(size_window*(1-overlap)):(sz(1)-size_window-shift);
y = (shift+1):round(size_window*(1-overlap)):(sz(2)-size_window-shift);

% iamge fractions
nx=numel(x);ny=numel(y);
mesh.nx = nx; mesh.ny = ny;
img_set.image = zeros(size_window, size_window, nx*ny);
img_set.position = zeros(nx*ny,2);

n=1;
for i=1:nx
    for j=1:ny
        img_set.image(:,:,n) = img(x(i):(x(i)+size_window-1),y(j):(y(j)+size_window-1),1);
        img_set.position(n,:) = [x(i),y(j)];
        n=n+1;
    end
end

% Visualization of the Meshing
showMeshResult
disp('     finish.')


%% Best Displacement Search %%%%-------------------------------------------
disp('4. Correlation Calculation / Displacement Calc.')
pause

N_data = size(img_set.position(:,1),1);

displacement = zeros(N_data, 2);
for i=1:N_data
    R_map = -Inf * zeros(shift*2+1);
    R_max = -Inf;
    x = img_set.position(i,1);
    y = img_set.position(i,2);

         
    n=1;
    for dx = -shift:shift
        for dy = -shift:shift
            % Take the second window
            tmp_img = img((x+dx):(x+size_window+dx-1),(y+dy):(y+size_window+dy-1),2);
            
            % get the coefficient between two image fractions
            c = corrcoef(img_set.image(:,:,i),tmp_img);
            R_map(n) = c(1,2);
            
            % Take Maximum Coefficient
            if R_max < c(1,2)
                R_max = c(1,2);
                displacement(i,:)= [dx,dy];
            end
            
            n=n+1;
            fprintf('Window %d/%d, %f%% \n',i,N_data,100*(n-1)/((2*shift+1)^2))
        end
    end

    if i == 1
        figure(4)
        showCorrelationMap
    end
end

disp('     finish.')



%% Velocity Calculation %%%%-------------------------------------------
disp('5. Get Velocity.')
pause

% Unit conversion from pixcel to velocity
velocity = pixcel2length * displacement / dt;

% visualization of the flow field without validation
figure(5)
showRawFlow
disp('     finish.')



%% Validation (Testing + Interpolation) %%%%-------------------------------------------
disp('6. Validation.')
pause

list = [];
for k=1:(mesh.nx-2)
    list = [list; (1+mesh.ny*(k-1)):((mesh.ny-2)+mesh.ny*(k-1))];
end

N=numel(list);
list_error = [];
for iteration = 1:N_iteration
    for i=1:N
        center = i + 1 + mesh.ny;
        
        % Get the target velocity
        u_c = velocity(center,:);
        
        % Calculate the reference velocity
        tmplist = [i:(i+2), ([i,i+2]+mesh.ny), ((i:(i+2))+2*mesh.ny)];
        u = velocity([tmplist, center],:);
        u_ref = median(velocity(tmplist,:));
        
        % Get the resdual length
        r_i = u - repmat(u_ref,[9,1]);
        STD = max(std(r_i));
        
        % TEST (false <=> error)
        test = ((val_scale*(STD+val_epsilon) - norm(u_c-u_ref)) > 0);
        
        %Validation
        if test == false
            list_error = [list_error, center];
            velocity(center,:) = u_ref;
        end
    end
end

% Visualize the final result
figure
showValidation
title('PIV Result')

% Visualize the Error points
figure(5)
hold on
scatter(img_set.position(list,2)+size_window/2+overlap*size_window,img_set.position(list,1)+size_window/2+overlap*size_window,'g','filled')
scatter(img_set.position(list_error,2)+size_window/2,img_set.position(list_error,1)+size_window/2,'r','filled')
hold off

disp('     finish.')

disp('PIC Finish.')