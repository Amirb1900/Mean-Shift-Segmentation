function imageData = ProcessData(image,sigmaS,sigmaR)

image = double(image);
[height,width,channels] = size(image);
imageData = zeros(height*width,channels+2);
k = 1;

for i = 1:height
    for j = 1:width
        imageData(k,:) = [i/(sigmaS),j/(sigmaS),reshape(image(i,j,:)/sigmaR,[1,channels]);];
        k = k + 1;
    end
end

end

