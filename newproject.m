close all; load('phsEnvlp.mat');
x = phsEnvlp(:,1); y = phsEnvlp(:,2); plot(x,y, '*');hold on;
h = plot(x(1),y(1), '-r', 'LineWidth', 3);
[px, py] = pathextractor(phsEnvlp, 100);
vid = VideoWriter('phsEnvlp.avi'); set(vid, 'FrameRate',5); 
open(vid); 
xmin = min(x); xmax = max(x);
ymin = min(y); ymax = max(y);
cx = (xmin + xmax)/2; cy = (ymin + ymax)/2;
xmin = cx - 1.5*(cx - xmin); xmax = cx + 1.5*(xmax - cx);
ymin = cy - 1.5*(cy - ymin); ymax = cy + 1.5*(ymax - cy);
axis([xmin, xmax, ymin, ymax]);
xmin = cx - 10*(cx - xmin); xmax = cx + 10*(xmax - cx);
ymin = cy - 10*(cy - ymin); ymax = cy + 10*(ymax - cy);
model = @(v, t)Objfun(v, x, y);
lb = [repmat(xmin,3,1); repmat(ymin,3,1)];
ub = [repmat(xmax,3,1); repmat(ymax,3,1)];
[vopt, iter] = LevenbergMaquardtFit(model, lb+rand(6,1).*(ub-lb), 1:100, ...
                 [px;py], 1e-6, @(v)plotfuncLm(v, x, y, h, vid));
close(vid);

function obj = Objfun(v, x, y)
    bzcurve = [x(1), y(1)];
    for t = 0.005:0.005:1
        pts = [x(1), y(1); reshape(v,3,2); x(end), y(end)];
        for i = 1:4
            pts = pts(1:end-1,:) + t*diff(pts);
        end
        bzcurve = [bzcurve; pts];
    end
    [intptsx, intptsy] = pathextractor(bzcurve, 100);
    obj = [intptsx; intptsy];
end

function plotfuncLm(pts, x, y, h, vid)
    h.XData = x(1); h.YData = y(1); 
    for t = 0.005:0.005:1
        intpts = [x(1), y(1); reshape(pts,3,2); x(end), y(end)];
        for i = 1:4
            intpts = intpts(1:end-1,:) + t*diff(intpts);
        end
        h.XData = [h.XData, intpts(1)];
        h.YData = [h.YData, intpts(2)];
    end
    drawnow; img = getframe(gcf); writeVideo(vid,img);
end

function [px, py] = pathextractor(xy, N)
    dxy = diff(xy);
    L   = cumsum([0;vecnorm(dxy, 2, 2)]);
    l   = linspace(L(1), L(end), N);
    pxy = interp1(L, xy, l);
    px  = pxy(:, 1); py  = pxy(:, 2);
end