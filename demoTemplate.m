clear
clc

% generate templates from image sources
chesscom=generateTemplate('img/c1.png'); %chess.com template
lichess=generateTemplate('img/l1.png'); % cburnett
templates=[chesscom lichess];

figure
montage([templates{1} templates{2} templates{3} templates{4} templates{5} templates{6}])


% load board image
img=imread('img/c2.png');

% get individual images of squares
squares=getSquares(img);

piece=pieceOutline(squares{47});

% resize template to size of piece
dims_piece=size(piece);

ccors={};
for i=1:length(templates)
    x=imresize(templates{i},dims_piece);

    % compute maximum of 2d cross correlation
    ccor=normxcorr2(x,piece);
    ccors{i}=ccor;
end

figure
montage([ccors{1} ccors{2} ccors{3} ccors{4} ccors{5} ccors{6}])
