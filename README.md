# Mean-Shift-Segmentation
The mean shift estimate of the gradient of a density function and the associated iterative procedure of mode seeking have been developed by Fukunaga and Hostetler. The Mean Shift algorithm clusters an n-dimensional data set (i.e., each data point is described by a feature vector of n values) by associating each point with a peak of the data set’s probability density. For each point, Mean Shift computes its associated peak by first defining a spherical window at the data point of radius r and computing the mean of the points that lie within the window. The algorithm then shifts the window to the mean and repeats until convergence. The output segmented image is then constructed using the cluster labels and peak values.

## Instructions
Use Main.m file to perform mean shift segmentation on the sample images provided. The optimized parameters for the images can be found in the word document provided.

## Example

### Original image
![Original image](https://user-images.githubusercontent.com/81757215/114262222-52404f80-9a11-11eb-8483-2c97ec1aa34d.jpg)

### Transformed image
![Transformed image](https://user-images.githubusercontent.com/81757215/114262225-52d8e600-9a11-11eb-822f-8761a4bd6b36.jpg)
