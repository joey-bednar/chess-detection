function Squares=getSquares(img)


    % reads in the image
    % pads the image to allow detection of side borders
    board = padarray(img,[1 1],0,'both');

    grayBoard = rgb2gray(board); % converts to grayscale
    %grayBoard = imresize(grayBoard, [400, 400]);
    cannyEdges = edge(grayBoard, 'canny'); % Uses canny edge detection to identify the cells
    %figure,imshow(grayBoard,[]), hold on % displays the image

    [H, theta, rho] = hough(cannyEdges); % Uses hough transform to 

    numPeaks = 18;
    peaks = houghpeaks(H, numPeaks,'Threshold',30);

    lines = houghlines(grayBoard,theta,rho,peaks,'FillGap',5,'minLen',15);

    points = [32, 3];

    
    for k=1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        points(k, 1) = lines(k).point1(1);
        points(k, 2) = lines(k).point1(2);
        points(k, 3) = lines(k).theta;
        % plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', 'r')
    end
    
    % hold off

    points = sortrows(points, 3);

    horzPoints = points(1:9, 2);
    horzPoints = sort(horzPoints);

    vertPoints = points(10:end, 1);
    vertPoints = sort(vertPoints);

    Squares = cell([1, 64]); % 64 length array of matrices that are 100x100x3
                             % every square of the board

    % Grabbing the area inside each square on the board
    % Goes column by column
    for i=1:length(horzPoints)-1 
        for j=1:length(vertPoints)-1
            Squares{(i-1)*8+j}(:,:, 1) = board(horzPoints(j):horzPoints(j+1), ...
                vertPoints(i):vertPoints(i+1), 1);
            Squares{(i-1)*8+j}(:,:, 2) = board(horzPoints(j):horzPoints(j+1), ...
                vertPoints(i):vertPoints(i+1), 2);
            Squares{(i-1)*8+j}(:,:, 3) = board(horzPoints(j):horzPoints(j+1), ...
                vertPoints(i):vertPoints(i+1), 3);
        end
    end


end