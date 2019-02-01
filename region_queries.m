addpath('../provided_code/');
n = 1072; %frame number
framesdir = './frames/';
siftdir = './sift/';

fnames = dir([siftdir '/*.mat']);

fname1 = [siftdir '/' fnames(n).name];
load(fname1, 'imname', 'descriptors','positions');
imname = [framesdir '/' imname]; % add the full path
im = imread(imname);
fprintf('\n\nUse the mouse to draw a polygon, double click to end it\n');
oninds = selectRegion(im, positions);
desc = descriptors(oninds,:);

desc = desc';
[membership, subkMeans,rms] = kmeansML(50,desc);
subkMeans = subkMeans';

n2 = dist2(descriptors,subkMeans);
Hist1 = zeros(50,1);
matches = zeros(5,2);
[minValues,indices] = min(n2,[],2);
for i= 1:length(indices)
   Hist1(indices(i,1),1) = Hist1(indices(i,1),1)+1;
end

for i = 1:length(fnames)
    fname2 = [siftdir '/' fnames(i).name];
    load(fname2,'descriptors');
    n2 = dist2(descriptors,subkMeans);
    Hist2 = zeros(50,1);
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


