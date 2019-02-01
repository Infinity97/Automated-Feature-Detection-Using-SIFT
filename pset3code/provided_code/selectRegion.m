function [oninds] = selectRegion(im, positions)

imshow(im);

h = impoly(gca, []);
api = iptgetapi(h);
nextpos = api.getPosition();

ptsin = inpolygon(positions(:,1), positions(:,2), nextpos(:,1), nextpos(:,2));
oninds = find(ptsin==1); 
