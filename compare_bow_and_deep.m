load('kMeans.mat','kMeans');
addpath('../provided_code/');
n = 335; %frame number
framesdir = './frames/';
siftdir = './sift/';
m = 2; %1-using bag of words,2-using AlexNet
fnames = dir([siftdir '/*.mat']);
if m == 1
    fname1 = [siftdir '/' fnames(n).name];
    load(fname1,'descriptors');
    n2 = dist2(descriptors,kMeans);
    Hist1 = zeros(1500,1);
    matches = zeros(10,2);
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

    subplot(3,4,1);
    fname = [siftdir '/' fnames(n).name];
    load(fname, 'imname');
    imname = [framesdir '/' imname];
    im = imread(imname);
    imshow(im);
    title(imname);
    for l = 1:10
        subplot(3,4,l+1);
        fname = [siftdir '/' fnames(matches(l,2)).name];
        load(fname, 'imname');
        imname = [framesdir '/' imname];
        im = imread(imname);
        imshow(im);
        title(imname);
    end
    suptitle('Using Bag of Words');
else
    matches = zeros(10,2);
   fname1 = [siftdir '/' fnames(n).name];
   Alex1 = load(fname1,'deepFC7'); 
   for i = 1:length(fnames)
        fname2 = [siftdir '/' fnames(i).name];
        Alex2 = load(fname2,'deepFC7');
        val = dot(Alex1.deepFC7,Alex2.deepFC7)/(norm(Alex1.deepFC7)*norm(Alex2.deepFC7));
        [minval,minindex] = min(matches);
        if minval(1) < val
          matches(minindex(1),1) = val;
          matches(minindex(1),2) = i;
        end
   end
    subplot(3,4,1);
    fname = [siftdir '/' fnames(n).name];
    load(fname, 'imname');
    imname = [framesdir '/' imname];
    im = imread(imname);
    imshow(im);
    title(imname);
    for l = 1:10
        subplot(3,4,l+1);
        fname = [siftdir '/' fnames(matches(l,2)).name];
        load(fname, 'imname');
        imname = [framesdir '/' imname];
        im = imread(imname);
        imshow(im);
        title(imname);
    end
    suptitle('Using AlexNet')
    
end