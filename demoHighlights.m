clear
clc

% load board image
img=imread('img/c2.png');

% get individual images of squares
squares=getSquares(img);

% get background color of squares
background_colors=[];
for i=1:length(squares)

    c_piece=squares{i};

    piece_grey=rgb2gray(c_piece);

    % crop out edge detection errors
    pad=2;
    c_piece=piece_grey(pad:end-pad,pad:end-pad);

    % generate histogram of pixel values
    h=imhist(c_piece,255);

    % most frequently occuring value is the background pixel value
    [~,back]=max(h);

    % add squares background color to a list
    background_colors=[background_colors back];
end

hist(background_colors,255)
xlabel('Color')
ylabel('Frequency')

 % get 2 background colors
c1=mode(background_colors);
background_colors(background_colors==c1)=NaN;
c2=mode(background_colors);
background_colors(background_colors==c2)=NaN;


% if no highlighted squares found, it is the start of the game and it is
% white to move
if all(isnan(background_colors))
    highlight_index=0;
    return
end

% highlighted squares are different than the rest
highlight_index=find(~isnan(background_colors));
if length(highlight_index)~=2
    error('less than 2 highlighted squares');
end

highlight_index


% initialize board
board=generateEmptyBoard();

% checks every square on the image for pieces
for i=1:length(squares)
   % get piece outline
   outline=pieceOutline(squares{i});
   
   % get piece shape from outline
   type=detectPieceShape(outline);
   
   % get piece color
   color=pieceColor(squares{i});
   
   % add piece with color/shape to correct square
   board=addPiece(board,type,color,i);
end
[tomove,en_passant]=lastMoveData(board,highlight_index)