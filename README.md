# Chessboard Detection with MATLAB
A 2D image of a chessboard is input to the MATLAB program. The locations of the pieces are detected using image processing techniques and translated into FEN. The resulting position in the FEN is analysed using Stockfish, an open-source chess engine, and the optimal move is calculated. The suggested move is shown by adding an arrow to the original image.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/out1.jpg?raw=true"  width="200" height="200">&nbsp;<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/out2.jpg?raw=true"  width="200" height="200">&nbsp;<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/out3.jpg?raw=true"  width="200" height="200">

## Detecting Squares
The input to the program is an image of a 2D chessboard. These are obtained as screenshots from chess.com or lichess.org. These can be boards with any background color, piece theme, or size.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/c1.png?raw=true"  width="200" height="200">&nbsp;<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/l1.png?raw=true"  width="200" height="200">&nbsp;<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/l2.png?raw=true"  width="200" height="200">

The image is split into individual squares by performing Canny edge detection on the grayscale image. This returns a binary image with 1s at the edges.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/canny.jpg?raw=true"  width="400" height="400">

The edges caused by the squares are separated from the edges caused by the pieces using a Hough transform. A maximum of 18 lines are returned to map out the squares on the board.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/hough.jpg?raw=true"  width="400" height="400">

The original image of the board can be separated into 64 squares using the coordinates of the lines. These individual images are used to perform piece detection.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/king.jpg?raw=true"  width="100" height="100">

## Detecting Pieces
Piece shapes are detected by computing a histogram of the grayscale image of each square. The peak of the histogram is the background color which is filtered out. Only one peak indicates that the square is empty.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/hist_piece.jpg?raw=true"  width="400" height="290">

The square image is converted into a binary image. The peak value in the histogram is 0 and all other values are 1. Any gaps in the shape are filled in with 1s.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/king_outline.jpg?raw=true"  width="100" height="100">

The outline is used to match the piece on the square to one of the known piece shapes. These are given in templates.mat.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/shapes.jpg?raw=true"  width="447" height="75">

A normalized 2D cross-correlation between the piece and the templates is performed to find the best match. Next, the color of the piece is calculated using a histogram of the grayscale square image. The background color (peak) is removed.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/hist_color.jpg?raw=true"  width="400" height="290">

The ratio of light pixels to dark pixels is used to determine the piece color. 

## Detecting Previous Move
The previous move is often displayed by highlighting the initial and final square of the piece that moved. The background of these highlighted squares is used to determine whose turn it is in the position and if capturing en passant is possible.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/en1.png?raw=true"  width="400" height="400">

The highlighted squares are computed using a histogram of the background of all of the squares on the board. The top two peaks are colors of the light and dark squares. The third peak is the background color of the highlighted squares. If no highlighted squares are found, it is assumed to be white's turn.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/hist_previous.jpg?raw=true"  width="400" height="290">

The initial square will not have a piece on it. The final square will have a piece. It will be the opposite player's turn. En passant is legal if a pawn has moved two squares.

## Calculating Best Move
The array of square images are converted into an 8x8 array of chars corresponding to the piece on each square. The label for each piece corresponds to the naming conventions used in FEN.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/c1.png?raw=true"  width="200" height="200">&nbsp;<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/chars.png?raw=true"  width="138" height="240">

This array is converted into FEN. Castling rights are assumed if the rooks and king are in their original locations.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/fen.png?raw=true"  width="503" height="90">

This FEN is used as the input to stockfish to calculate the best move. Stockfish outputs the best move via the terminal. The output is filtered and translated into a starting and ending square.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/stockfish.png?raw=true"  width="589" height="257">

These squares are used to draw an arrow over the original image.

