function pts = PhaseEnvelopBezierCurve(filename, xmin, xmax, ymin, ymax, N)
    img = flipud(imread(filename)); 
    f = figure(1);  f.Color = [1,1,1];
    imgplot = image('CData',img,'XData',[0 1],'YData',[0, 1]); hold on;
    %recalibrate x
    title("select the minimum and maximum x coordinates")
    ptx = ginput(2); X = ptx(:,1); dpts = diff(X); f = (xmax- xmin)/dpts;
    imgplot.XData = [xmin - (X(1) - imgplot.XData(1))*f, ...
                     (imgplot.XData(2) - X(2))*f + xmax];
    %recalibrate y
    title("select the minimum and maximum y coordinates")
    pty = ginput(2); Y = pty(:,2); dpts = diff(Y); f = (ymax- ymin)/dpts;
    imgplot.YData = [ymin - (Y(1) - imgplot.YData(1))*f, ...
                     (imgplot.YData(2) - Y(2))*f + ymax];

    axis([xmin, 2*xmax-xmin, ymin, 2*ymax-ymin])
    pts = ginput(N);
    H = []; n = size(pts,1);
    for i = 1:n-1
        if(i == 1)
            h = plot(pts(:,1), pts(:,2),'LineWidth', 3); 
            hold on; h.Color = [0.9,0.9,0.9];
        else
            h = plot(pts(:,1), pts(:,2), '-o');
        end
        H = [H, h];
        text(pts(i,1), pts(i,2), ["$P_{",num2str(i),"}$"], ...
            "interpreter", "latex");
    end
    text(pts(n,1), pts(n,2), ["$P_{",num2str(n),"}$"], ...
        "interpreter", "latex"); n = n - 1;
    hfinal = plot(pts(1,1), pts(1,2), '-r', 'LineWidth', 3); hold off;
    for t = 0.005:0.005:1
        intpts = pts(1:end-1,:) + t*diff(pts);
        for i = 2:n
            h = H(i);
            h.XData = intpts(:,1); h.YData = intpts(:,2); 
            intpts = intpts(1:end-1,:) + t*diff(intpts);
        end
        hfinal.XData = [hfinal.XData, intpts(1)];
        hfinal.YData = [hfinal.YData, intpts(2)];
        drawnow;
    end
end