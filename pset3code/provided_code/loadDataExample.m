
addpath('./code/');
framesdir = './frames/';
siftdir = './sift/';

fnames = dir([siftdir '/*.mat']);

fprintf('reading %d total files...\n', length(fnames));

N = 100; 
    
% Loop through all the data files found
for i=1:length(fnames)

    fprintf('reading frame %d of %d\n', i, length(fnames));
    
    % load that file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    numfeats = size(descriptors,1);
    
    % read in the associated image
    imname = [framesdir '/' imname]; 
    im = imread(imname);

    
    % display the image and its SIFT features drawn as squares
    fprintf('imname = %s contains %d total features, each of dimension %d\n', imname, numfeats, size(descriptors,2));
    imshow(im);
    displaySIFTPatches(positions, scales, orients, im); % another function
    title('showing all features');
    fprintf('hit a key to continue.\n');
    pause;
    
    % now display the same image but only show N of the features
    fprintf('now showing a random subset of %d of those for visualization purposes only...\n', N);
    randinds = randperm(numfeats);
    clf;
    imshow(im);
    displaySIFTPatches(positions(randinds(1:min([N,numfeats])),:), scales(randinds(1:min([N,numfeats]))), orients(randinds(1:min([N,numfeats]))), im); 
    title('showing N features');
    fprintf('hit a key to continue.\n');
    pause;
    
    % now show how to select a subset of the features using polygon drawing
    fprintf('\n\nuse the mouse to draw a polygon, double click to end it\n');
    oninds = selectRegion(im, positions);
    
    % display only those features
    imshow(im);
    displaySIFTPatches(positions(oninds,:), scales(oninds), orients(oninds), im); 
    plot(positions(:,1), positions(:,2), 'ro');
    title('showing features within region of interest in cyan, and all feature positions in red');
    
    
    fprintf('hit a key to continue, ctrl-c to stop.\n\n\n');
    pause;
    
    clear descriptors positions scales orients im
    
end
