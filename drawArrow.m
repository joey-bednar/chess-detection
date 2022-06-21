% creates arrow indicating best move over the board image
function drawArrow(move,img)

    % split into chars
    move=split(move,'');
    move=move(~cellfun('isempty',move));

    % convert text to square coordinates
    % separate into start coords and end coords
    col_start=double(move{1})-96;
    row_start=9-str2num(move{2});

    col_end=double(move{3})-96;
    row_end=9-str2num(move{4});

    Squares=getSquares(img);

    % get average dimension of squares
    x_avg=0;
    y_avg=0;
    for i=1:length(Squares)
        dims=size(Squares{i});
        x_avg=x_avg+dims(1);
        y_avg=y_avg+dims(2);
    end
    x_avg=round(x_avg/64);
    y_avg=round(y_avg/64);

    % when plotting is in middle of first square
    origin=[round(x_avg/2),round(y_avg/2)];

    % calculate arrow coordinates
    start_x = origin(1)+(col_start-1)*x_avg;
    start_y = origin(2)+(row_start-1)*y_avg;
    end_x = x_avg*(col_end-col_start);
    end_y = y_avg*(row_end-row_start);
    
    % create arrow array
    arrow=[start_x,start_y,end_x,end_y];
    
    % display image with arrows showing best move for white and black
    figure(1)
    imshow(img)
    hold on
    quiver(arrow(1),arrow(2),arrow(3),arrow(4),0,'Linewidth',5,'MaxHeadSize',0.4)
    hold off

end