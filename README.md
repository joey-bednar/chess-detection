# Chessboard Detection with MATLAB
A 2D image of a chessboard is input to the MATLAB program. The locations of the pieces are detected using image processing techniques and translated into FEN. The resulting position in the FEN is analysed using Stockfish, an open-source chess engine, and the optimal move is calculated. The suggested move is shown by adding an arrow to the original image.

## Detecting Squares
The input to the program is an image of a 2D chessboard. These are obtained as screenshots from chess.com or lichess.org. These can be boards with any background color, piece theme, or size.

<img src="https://github.com/joey-bednar/chess-detection/blob/main/img/c1.png?raw=true"  width="200" height="200"><img src="https://github.com/joey-bednar/chess-detection/blob/main/img/l1.png?raw=true"  width="200" height="200"><img src="https://github.com/joey-bednar/chess-detection/blob/main/img/l2.png?raw=true"  width="200" height="200">

The image is split into individual squares by performing Canny edge detection on the grayscale image. This returns a binary image with 1s at the edges.

![Canny edge detection](https://github.com/joey-bednar/chess-detection/blob/main/img/canny.jpg?raw=true)

The edges caused by the squares are separated from the edges caused by the pieces using a Hough transform. A maximum of 18 lines are returned to map out the squares on the board.

![Hough transform](https://github.com/joey-bednar/chess-detection/blob/main/img/hough.jpg?raw=true)

The original image of the board can be separated into 64 squares using the coordinates of the lines. These individual images are used to perform piece detection.

![White king](https://github.com/joey-bednar/chess-detection/blob/main/img/king.jpg?raw=true)
<!--
## Detecting Pieces

## Detecting Previous Move

## Calculating Best Move

## Examples
-->
