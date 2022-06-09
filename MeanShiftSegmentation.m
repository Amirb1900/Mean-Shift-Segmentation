function segmentedImage = MeanShiftSegmentation(image_original,gray_rgb_luv,sigmaS,sigmaR,M)

%% Preprocessing data
image = imresize(image_original,[256,256]);

if gray_rgb_luv == 0
    % For grayscale image
    image = rgb2gray(image);
else
    if gray_rgb_luv == 2
        cform = makecform('srgb2xyz');
        xyz_img = applycform(image,cform);
        cform = makecform('xyz2uvl');
        image = applycform(xyz_img,cform)*255;
    end
end

imageData = ProcessData(image,sigmaS,sigmaR);
%% Find peaks and labels
tic
radius = 4;
tolerance = 1; % Tolerance for convergence
peaks = zeros(size(imageData)); % storing for every point
labels = zeros(length(imageData),1); % storing for every point

% Label for 1st data point (For initialization)
label = 1;
label_values = zeros(size(image,1)*size(image,2),size(image,3)); % stores only for each class
peak = findpeakopt(imageData,1,radius,tolerance);
diff = peak - imageData;
diff_norm = vecnorm(diff')';
[~,minInd] = min(diff_norm);
label_values(label,:) = imageData(minInd,3:end); % Find colour values
peaks(1,:) = peak; % Assigning the peak for the current index
labels(1,1) = label; % Assigning the label (e.g. 1,2,3)
labeled_indices = [];

% Label for 2nd data point onwards
all_indices = 1:length(imageData);
indices_list = 2:length(imageData);

while ~isempty(indices_list)
    idx = indices_list(1); % Index of current point
    [peak,cumpts] = findpeakopt(idx,imageData,all_indices,radius,tolerance); % Find peak of the current point (slow) - Some reassigning takes place but more stable
    %[peak,cumpts] = findpeakopt(idx,imageData,indices_list,radius,tolerance); % Find peak of the current point (fast) - Does not work when not enough points within radius
    peaks(indices_list(1),:) = peak;
    diff = peak - peaks(1:indices_list(1)-1,:); % Compare with previous peaks
    diff_norm = vecnorm(diff')'; % Find the distance of current peak to previous peaks
    [minDiff,minInd] = min(diff_norm); % Find the index of peak that is closest to current peak
    
    diff = peak - imageData; % Find neighbors that are within the specified radius at the peak
    diff_norm = vecnorm(diff')'; % Find the distance of neighbors
    nbr_ind = setdiff(all_indices(diff_norm < radius),labeled_indices); % Find indices of unlabelled neighbors
    nbr_ind = union(nbr_ind,cumpts); % Remove the duplicate points
    peaks(nbr_ind,:) = repmat(peak,length(nbr_ind),1); % Assign the same peak values for neighbors
    
    if minDiff <=  radius % Assign the label of the closest peak if minDiff <= radius
        labels(indices_list(1),1) = labels(minInd,1);
        labels(nbr_ind,1) = labels(minInd,1); % Assign the same label for neighbors
    else 
        label = label + 1;
        labels(indices_list(1),1) = label;
        labels(nbr_ind,1) = label; % Assign the same label for neighbors
        diff = peak - imageData;
        diff_norm = vecnorm(diff')';
        [~,minInd] = min(diff_norm);
        label_values(label,:) = imageData(minInd,3:end); % Find the color values
    end
    
    if any(nbr_ind == indices_list(1)) % Keep track of nbr indices (including current ind)
        labeled_indices = [labeled_indices, nbr_ind]; % current ind in nbr_ind
    else
        labeled_indices = [labeled_indices, indices_list(1),nbr_ind]; % current ind not in nbr_ind
    end
    
    indices_list(1) = []; % Remove the first element of indices array
    indices_list = setdiff(indices_list,nbr_ind); % Remove the indices neighbors (including current ind)

end
toc
%% Constructing segmented image
labels_with_intensity = zeros(length(labels),size(image,3));

for ind = 1:label
    if length(labels(labels == ind)) > M
        labels_with_intensity(labels == ind,:) = repmat(label_values(ind,:),[sum(labels == ind),1])*sigmaR;
    end
end

[r,c,ch] = size(image);
labels_shaped = uint8(permute(reshape(labels_with_intensity,[r,c,ch]),[2 1 3]));

if ch == 3 && gray_rgb_luv == 2
    cform = makecform('uvl2xyz');
    labels_shaped = applycform(double(labels_shaped)/255,cform);
    cform = makecform('xyz2srgb');
    labels_shaped = uint8(applycform(labels_shaped,cform)*255);
end

for i = 2:r
    for j = 2:c
        if all(labels_shaped(i,j,:) == 0)
            labels_shaped(i,j,:) = labels_shaped(i-1,j-1,:);
        end
    end
end
           
[r,c,~] = size(image_original);
segmentedImage = imresize(labels_shaped,[r,c],'nearest');
