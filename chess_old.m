clear
clc

%% Example Usage

img=imread('img/c2.png');

%every square of the board
dividedBoard = getSquares(img);

%% Rest

% %generate an empty board data stucture
% board = zeros(8,8);
% 
% %for each square, detect piece and add to data structure
% % ======= piece symbols ========
% % king:   k   knight: n
% % queen:  q   rook:   r
% % bishop: b   pawn:   p
% for i=1:64
%     col = floor((i-1)/8)+1;
%     row = mod(i, 8);
%     if row == 0
%         row = i/8;
%     end
%     piece = piece_detection(rgb2gray(dividedBoard{i}))
%     if piece ~= 'z'
%         board(uint8(row),uint8(col))= piece;
%     end
% end




% REPLACE THIS WITH PIECE RECOGNITION
% USE THIS TO CREATE BOARD LAYOUT
% for now, set position to same as board image manually
% board=[0 0 0 0 98 0 107 0;0 0 0 0 0 112 112 112;0 0 0 0 112 0 0 0;0 0 0 112 80 0 80 0;0 0 0 80 0 0 0 0;0 0 80 80 0 0 0 0;112 0 0 0 0 0 75 80;0 113 0 0 0 82 0 0];
% 
% 
% %%% for white %%%%
% 
% %get FEN
% FEN=generateFEN(board,'w');
% 
% FEN="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
% 
% % get best move
% move=evaluatePosition(FEN);
% 
% % get arrow coordinates from move
% arrow_w=move2arrow(move,img);
% 
% 
% %%%% for black %%%%
% 
% % get FEN
% FEN=generateFEN(board,'b');
% 
% FEN="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1";
% 
% % get best move
% move=evaluatePosition(FEN);
% 
% % get arrow coordinates from move
% arrow_b=move2arrow(move,img);
% 
% 
% 
% % display image with arrows showing best move for white and black
% figure(1)
% imshow(img)
% hold on
% quiver(arrow_w(1),arrow_w(2),arrow_w(3),arrow_w(4),0,'Linewidth',5,'MaxHeadSize',0.4)
% quiver(arrow_b(1),arrow_b(2),arrow_b(3),arrow_b(4),0,'Linewidth',5,'MaxHeadSize',0.4)
% hold off





%% Functions



function identified_piece = piece_detection(square)
    % function identified_piece = piece_detection(square);
    % The input is an individual square taken from the original image of the
    % board.
    % The output is a classification of what that piece is:
    %   no piece, black pawn, white pawn, black knight, white knight, black
    %   rook, white rook, black bishop, white bishop, black queen, white queen,
    %   black king, and white king
    % This function will identify what piece if any is in each input square.

    % IMPORTANT: Must load in template .mat files first
    load('bishop1.mat')
    load('king1.mat')
    load('knight1.mat')
    load('pawn1.mat')
    load('queen1.mat')
    load('rook1.mat')


    numfiles = 15; % total number of images in the template database

    % Resetting count for each piece
    blackrooknum = 0;
    whiterooknum = 0;
    blackpawnnum = 0;
    whitepawnnum = 0;
    blackknightnum = 0;
    whiteknightnum = 0;
    whitebishopnum = 0;
    blackbishopnum = 0;
    whitequeennum = 0;
    blackqueennum = 0;
    whitekingnum = 0;
    blackkingnum = 0;

    % Making input image binary image and only looking at the top half
    [h, w] = size(square);
    cropped_sq = square(1:floor(h/2), 1:w , :); % only looking at top half of the image
    cropped_sq = cropped_sq>100; % creating binary image
    cropped_sq = imresize(cropped_sq, [70, 100]); % resizine to 100x70 image
    e = cropped_sq; % e is the input for the cross correlation

    % Color identifiation
    [hr, wr] = size(cropped_sq); % getting dimensions of cropped image
    blackorwhite = cropped_sq(45:hr-1, 25:wr - 25, :); % resizing image to get rid of background
    numofw = bwarea(blackorwhite); % area of white pixels
    numofb = bwarea(~blackorwhite); % area of black pixels

    if or(numofb == 0, numofw == 0) % if only one color in the image, no piece there
        identified_piece = 'z';
    else % identifying the color of the piece and the type of piece
        if numofw > numofb % if more white pixels than black pixels
            color = 1; % white
        else % if more black pixels than white pixels
            color = 0; % black
        end

        % Performing the normalized cross correlation of the input piece with each
        % of the templates
        for i = 1: numfiles
            % BLACK ROOK
            t = rook(i).blackbin;
            t = uint8(t); % converting to uint8 to perform cross correlation
            rookbbin = normxcorr2(t, e); % cross correlation
            [hr, wr] = size(rookbbin);
            rookbbin = imresize(rookbbin, [170, 200]); % resizing the correlation map
            rookbbin = rookbbin(1:hr-20, 40:wr - 30, :); % cropping out background
            blackrooknum = blackrooknum + sum(rookbbin(:)>0.5); % counting pixels > 0.5

            % BLACK PAWN
            t = pawn(i).blackbin;
            t = uint8(t);
            pawnbbin = normxcorr2(t, e);
            [hr, wr] = size(pawnbbin);
            pawnbbin = imresize(pawnbbin, [170, 200]);
            pawnbbin = pawnbbin(1:hr-0, 40:wr - 30, :);
            blackpawnnum = blackpawnnum + sum(pawnbbin(:)>0.51);

            % BLACK KNIGHT
            t = knight(i).blackbin;
            t = uint8(t);
            knightbbin = normxcorr2(t, e);
            [hr, wr] = size(knightbbin);
            knightbbin = imresize(knightbbin, [170, 200]);
            knightbbin = knightbbin(1:hr-20, 40:wr - 30, :);
            blackknightnum = blackknightnum + sum(knightbbin(:)>0.55);

            % BLACK BISHOP
            t = bishop(i).blackbin;
            t = uint8(t);
            bishopbbin = normxcorr2(t, e);
            [hr, wr] = size(bishopbbin);
            bishopbbin = imresize(bishopbbin, [170, 200]);
            bishopbbin = bishopbbin(1:hr-20, 40:wr - 30, :);
            blackbishopnum = blackbishopnum + sum(bishopbbin(:)>0.54);

            % BLACK QUEEN
            t = queen(i).blackbin;
            t = uint8(t);
            queenbbin = normxcorr2(t, e);
            [hr, wr] = size(queenbbin);
            queenbbin = imresize(queenbbin, [170, 200]);
            queenbbin = queenbbin(1:hr-20, 40:wr - 30, :);
            blackqueennum = blackqueennum + sum(queenbbin(:)>0.49);

            % BLACK KING
            t = king(i).blackbin;
            t = uint8(t);
            kingbbin = normxcorr2(t, e);
            [hr, wr] = size(kingbbin);
            kingbbin = imresize(kingbbin, [170, 200]);
            kingbbin = kingbbin(1:hr-20, 40:wr - 30, :);
            blackkingnum = blackkingnum + sum(kingbbin(:)>0.54);

            % WHITE ROOK
            t = rook(i).whitebin;
            t = uint8(t);
            rookwbin = normxcorr2(t, e);
            [hr, wr] = size(rookwbin);
            rookwbin = imresize(rookwbin, [170, 200]);
            rookwbin = rookwbin(1:hr-20, 40:wr - 30, :);
            whiterooknum = whiterooknum + sum(rookwbin(:)>0.45);

            % WHITE PAWN
            t = pawn(i).whitebin;
            t = uint8(t);
            pawnwbin = normxcorr2(t, e);
            [hr, wr] = size(pawnwbin);
            pawnwbin = imresize(pawnwbin, [170, 200]);
            pawnwbin = pawnwbin(1:hr-0, 40:wr - 30, :);
            whitepawnnum = whitepawnnum + sum(pawnwbin(:)>0.5);

            % WHITE KNIGHT
            t = knight(i).whitebin;
            t = uint8(t);
            knightwbin = normxcorr2(t, e);
            [hr, wr] = size(knightwbin);
            knightwbin = imresize(knightwbin, [170, 200]);
            knightwbin = knightwbin(10:hr-20, 40:wr - 30, :);
            whiteknightnum = whiteknightnum + sum(knightwbin(:)>0.4);


            % WHITE BISHOP
            t = bishop(i).whitebin;
            t = uint8(t);
            bishopwbin = normxcorr2(t, e);
            [hr, wr] = size(bishopwbin);
            bishopwbin = imresize(bishopwbin, [170, 200]);
            bishopwbin = bishopwbin(1:hr-20, 55:wr - 45, :);
            whitebishopnum = whitebishopnum + sum(bishopwbin(:)>0.57);

            % WHITE QUEEN
            t = queen(i).whitebin;
            t = uint8(t);
            queenwbin = normxcorr2(t, e);
            [hr, wr] = size(queenwbin);
            queenwbin = imresize(queenwbin, [170, 200]);
            queenwbin = queenwbin(1:hr-20, 40:wr - 30, :);
            whitequeennum = whitequeennum + sum(queenwbin(:)>0.49);

            % WHITE KING
            t = king(i).whitebin;
            t = uint8(t);
            kingwbin = normxcorr2(t, e);
            [hr, wr] = size(kingwbin);
            kingwbin = imresize(kingwbin, [170, 200]);
            kingwbin = kingwbin(30:hr-5, 40:wr - 30, :);
            whitekingnum = whitekingnum + sum(kingwbin(:)>0.72);
        end

        % Final evaluation of what the piece is
        pieces_values = [(blackpawnnum + whitepawnnum), (blackrooknum + whiterooknum), (whiteknightnum + blackknightnum),(whitebishopnum + blackbishopnum), (whitequeennum + blackqueennum), (whitekingnum + blackkingnum)];
        maxpiece = max(pieces_values); % for idetifying the piece
            if maxpiece == blackpawnnum + whitepawnnum
                piece_is = 'p';
            elseif maxpiece == blackrooknum + whiterooknum
                piece_is = 'r';
            elseif maxpiece == whiteknightnum + blackknightnum
                piece_is = 'n';
            elseif maxpiece == whitebishopnum + blackbishopnum
                piece_is = 'b';
            elseif maxpiece == whitequeennum + blackqueennum
                piece_is = 'q';
            elseif maxpiece == whitekingnum + blackkingnum
                piece_is = 'k';
            end
           %if detected white king...
           if (color == 1 && piece_is == 'k' && (blackpawnnum + whitepawnnum) > 45)
               piece_is = 'p';
           end
        %set piece color uppercase = white lowercase = black
        if color == 1
            piece_is = upper(piece_is);
        end
        identified_piece = piece_is;
    end
end



function arrow=move2arrow(move,img)

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
    close

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

    
    start_x = origin(1)+(col_start-1)*x_avg;
    start_y = origin(2)+(row_start-1)*y_avg;

    end_x = x_avg*(col_end-col_start);
    end_y = y_avg*(row_end-row_start);
    
    arrow=[start_x,start_y,end_x,end_y];

end

function Squares=getSquares(img)


    % reads in the image
    % pads the image to allow detection of side borders
    board = padarray(img,[1 1],0,'both');

    grayBoard = rgb2gray(board); % converts to grayscale
    %grayBoard = imresize(grayBoard, [400, 400]);
    cannyEdges = edge(grayBoard, 'canny'); % Uses canny edge detection to identify the cells
    figure,imshow(grayBoard,[]), hold on % displays the image

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
        plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', 'r')
    end
    
    hold off

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


% ONLY WORKS ON LINUX WITH STOCKFISH INSTALLED
% outputs the best move given an FEN
function bestmove=evaluatePosition(FEN)
    % Runs stockfish 8 in Linux terminal to analyze chess position
    % Loads board position using FEN
    % Computes position and waits 1sec for process to finish
    % Outputs multiple top computer moves
    % Moves filtered to only show best move
    [~,cmdout]=system('( echo "position fen '+FEN+'"; echo "go"; sleep 1 )|stockfish|grep bestmove')
    out=split(cmdout)
    bestmove=out{2}
end


% returns board with piece removed from given square
function board=removePiece(board,row,col)
    board(9-row,col)=0;
end



% returns board with piece added to square
% ======= piece symbols ========
% king:   k   knight: n
% queen:  q   rook:   r
% bishop: b   pawn:   p
function board=addPiece(board,piece,color,row,col)

    if color=="white"
        piece=upper(piece);
    elseif color=="black"
        piece=lower(piece);
    else
        error('color invalid')
    end
    
    board(9-row,col)=piece;
    
end




% returns 8x8 board array of zeros
function board=generateEmptyBoard()
    board=zeros(8,8);
end





% returns 8x8 board array with piece layout:

% rnbqkbnr
% pppppppp
%
%
%
%
% PPPPPPPP
% RNBQKBNR

% white pieces are on the bottom
function board=generateStartingBoard()
    % init board
    board = zeros(8,8);

    % add black pieces
    board(9-7,1:8)='p';
    board(9-8,[1,8])='r';
    board(9-8,[2,7])='n';
    board(9-8,[3,6])='b';
    board(9-8,4)='q';
    board(9-8,5)='k';

    % add white pieces
    board(9-2,1:8)='P';
    board(9-1,[1,8])='R';
    board(9-1,[2,7])='N';
    board(9-1,[3,6])='B';
    board(9-1,4)='Q';
    board(9-1,5)='K';
end




% given 8x8 array board, create FEN string that will
% be used for chess engine analysis
% color specifies whose move it is in the position
% White: w, Black: b
function fen=generateFEN(board,color)

    % init fen and whitespace count
    fen="";
    count=0;

    % loop through board positions
    for j=8:-1:1
        for i=1:8
            % add piece to fen
            if board(9-j,i)~=0

                % display number of empty squares in row
                if count~=0
                    fen=fen+count;
                    count=0;
                end
                % add piece to string
                fen = fen+char(board(9-j,i));
            
            % if no piece on square, increment empty space count
            else
                count=count+1;
            end
        end

        % if row ends with nonzero count, display empty space count
        if count~=0
            fen=fen+count;
            count=0;
        end

        % add slash at end of row
        fen=fen+"/";
    end

    % remove trailing slash
    fen=split(fen,"");
    fen=join(fen(1:end-2),"");

    % assumptions:
    % - white to move
    % - no castling
    % - en passant is not a legal move
    % - fifty-move rule unimportant
    fen=fen+" "+color+" - - 0 1";
    %fen=fen+" w KQkq - 0 1";

end