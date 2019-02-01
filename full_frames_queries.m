load('kMeans.mat','kMeans');
addpath('../provided_code/');
n = 24; %frame number
framesdir = './frames/';
siftdir = './sift/';

fnames = dir([siftdir '/*.mat']);
fname1 = [siftdir '/' fnames(n).name];
load(fname1,'descriptors');
n2 = dist2(descriptors,kMeans);
Hist1 = zeros(1500,1);
matches = zeros(5,2);
[minValues,indices] = min(n2,[],2);
for i= 1:length(indices)
   Hist1(indices(i,1),1) = Hist1(indices(i,1),1)+1;
end

for i = 1:length(fnames)
    fname2 = [siftdir '/' fnames(i).name];
    load(fname2,'descriptors');
    n2 = dist2(descriptors,kMeans);
    Hist2 = zeros(1500,1);
    [minValues,indices] = min(n2,[],2);
    for k= 1:length(indices)
        Hist2(indices(k,1),1) = Hist2(indices(k,1),1)+1;
    end
    val = dot(Hist1,Hist2)/(norm(Hist1)*norm(Hist2));
    [minval,minindex] = min(matches);
    if minval(1) < val
        matches(minindex(1),1) = val;
        matches(minindex(1),2) = i;
    end
end

subplot(2,3,1);
fname = [siftdir '/' fnames(n).name];
load(fname, 'imname');
imname = [framesdir '/' imname];
im = imread(imname);
imshow(im);
title(imname);
for l = 1:5
    subplot(2,3,l+1);
    fname = [siftdir '/' fnames(matches(l,2)).name];
    load(fname, 'imname');
    imname = [framesdir '/' imname];
    im = imread(imname);
    imshow(im);
    title(imname);
end




