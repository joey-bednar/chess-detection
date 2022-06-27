clear
clc

% load board image
img=imread('../img/cas1.png');

% get individual images of squares
squares=getSquares(img);

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

% get the indices of highlighted squares
highlight_index=backgroundSquares(squares);

% find the last move made as indicated by the highlighted squares
% from this, determine who moves next and if en passant is possible
[tomove,en_passant]=lastMoveData(board,highlight_index);

% generate FEN
fen=generateFEN(board,tomove,en_passant);

% use Stockfish to calculate the best move
move=evaluatePosition(fen);

% draw the best move arrow over the image
drawArrow(move,img);

