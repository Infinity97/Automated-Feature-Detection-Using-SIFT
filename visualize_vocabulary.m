addpath('../provided_code/');
framesdir = './frames/';
siftdir = './sift2/';
fnames = dir([siftdir '/*.mat']);
fname = [siftdir '/' fnames(1).name];
load(fname, 'descriptors');
A = descriptors;
for i=2:length(fnames)
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'descriptors');
    A = vertcat(A,descriptors);
end
A = A';
[membership,kMeans,rms] = kmeansML(1500,A);
kMeans = kMeans';
x = kMeans(1,:);
fname = [siftdir '/' fnames(1).name];
load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
numfeats = size(descriptors,1);
imname = [framesdir '/' imname];
im = imread(imname);
n = dist2(x,descriptors);
[row,col] = find(n < 0.50);
for i= 1:25
    subplot(5,5,i);
    patch = getPatchFromSIFTParameters(positions(col(i),:), scales(col(i)), orients(col(i)), rgb2gray(im));
    imshow(patch);
end