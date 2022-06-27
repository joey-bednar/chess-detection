% returns binary image of piece outline
function binary_piece=pieceOutline(piece_img)
    % convert to grayscale
    piece_grey=rgb2gray(piece_img);

    % crop out edge detection errors
    pad=2;
    c_piece=piece_grey(pad:end-pad,pad:end-pad);

    % generate histogram of pixel values
    h=imhist(c_piece,255);

    % most frequently occuring value is the background pixel value
    [~,back]=max(h);

    % filter out background pixels
    h(back)=0;

    % make binary outline of piece, fill in any holes
    c_piece(c_piece==back)=1;
    c_piece(c_piece~=1)=255;
    c_piece(c_piece==1)=0;
    c_piece=imfill(c_piece,'holes');
    binary_piece = c_piece > 0;
end