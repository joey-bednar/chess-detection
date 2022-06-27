% gets piece color from square image: 'white' or 'black'
function piece_color = pieceColor(piece_img)
    % convert to grayscale
    piece_grey=rgb2gray(piece_img);

    % crop out edge detection errors
    pad=2;
    c_piece=piece_grey(pad:end-pad,pad:end-pad);

    % generate histogram of pixel values
    h=imhist(c_piece,255);
    %histogram(c_piece,255)

    % most frequently occuring value is the background pixel value
    [~,back]=max(h);

    % filter out background pixels
    h(back)=0;
    
    % count number of black and white pixels
    midpoint=256/2;
    black=sum(h(1:midpoint));
    white=sum(h(midpoint:end));
    
    % piece color determined by ratio of white to black pixels.
    % pieces can have black outline so the threshold should not be 1
    threshold=0.6;
    
    if white/black < threshold
        piece_color='b';
    else
        piece_color='w';
    end
end