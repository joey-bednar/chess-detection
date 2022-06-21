% load board image
img=imread('img/c2.png');

% get individual images of squares
squares=getSquares(img);

piece_img=squares{47};

% convert to grayscale
piece_grey=rgb2gray(piece_img);

% crop out edge detection errors
pad=2;
c_piece=piece_grey(pad:end-pad,pad:end-pad);

% generate histogram of pixel values
h=imhist(c_piece,255);

figure
stem(0:254,h)
xlabel('Color')
ylabel('Frequency')
axis([0 255 0 8000])

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

figure
imshow(binary_piece)

figure
stem(0:254,h)
xlabel('Color')
ylabel('Frequency')
axis([0 255 0 8000])