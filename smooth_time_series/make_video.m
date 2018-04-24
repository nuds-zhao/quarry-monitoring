function make_video(root, name)
delay = 0.9;

d = dir([root, '*.tif']);

v = VideoWriter(name, 'MPEG-4');
v.FrameRate = 1/delay;
v.Quality = 99;
open(v);

for i = 1:length(d)
    disp(d(i).name);
    b = imread([root, d(i).name]);
    writeVideo(v, b);
end;

close(v);