function [peak,cumpts] = findpeakopt(idx,imageData,indices,radius,tolerance)

peak = imageData(idx,:);
imageData = imageData(indices,:);
cumpts = [];
diff = peak - imageData; % Find neighbors that are within the specified radius
diff_norm = vecnorm(diff')'; % Find the distance of neighbors
addpts = setdiff(indices(diff_norm < (radius*0.75)),cumpts); % Find indices of new neighbors along the path
cumpts = [cumpts addpts];
change = inf;

while change > tolerance
    diff = abs(peak - imageData);
    dist = vecnorm(diff')';
    peakNew = mean(imageData(dist < radius,:));
    change = norm(peakNew - peak);
    peak = peakNew;
    
    diff = peak - imageData; % Find neighbors that are within the specified radius
    diff_norm = vecnorm(diff')'; % Find the distance of neighbors
    addpts = setdiff(indices(diff_norm < (radius*0.75)),cumpts); % Find indices of new neighbors along the path
    cumpts = [cumpts addpts];
end

end