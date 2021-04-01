function peak = findpeak(imageData,idx,radius,tolerance)

peak = imageData(idx,:);
change = inf;

while change > tolerance
    diff = abs(peak - imageData);
    dist = vecnorm(diff')';
    peakNew = mean(imageData(dist < radius,:));
    change = norm(peakNew - peak);
    peak = peakNew;
end

end

