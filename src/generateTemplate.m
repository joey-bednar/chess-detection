% generates piece shape template from image of starting position
function templates=generateTemplate(img_str)

    % use starting position image
    img=imread(img_str);

    % get all squares from starting position
    dividedBoard = getSquares(img);

    % define piece locations based on starting position
    % empty_light = uint8(dividedBoard{3});
    % empty_dark = uint8(dividedBoard{4});
    % 
    % b_rook=uint8(dividedBoard{1});
    % b_pawn=uint8(dividedBoard{2});
    % b_knight=uint8(dividedBoard{9});
    % b_bishop=uint8(dividedBoard{17});
    % b_queen=uint8(dividedBoard{25});
    % b_king=uint8(dividedBoard{33});

    w_rook=uint8(dividedBoard{8});
    w_pawn=uint8(dividedBoard{7});
    w_knight=uint8(dividedBoard{16});
    w_bishop=uint8(dividedBoard{24});
    w_queen=uint8(dividedBoard{32});
    w_king=uint8(dividedBoard{40});

    % make piece template outlines using white pieces
    pieces={w_pawn w_rook w_knight w_bishop w_queen w_king};
    for i=1:length(pieces)
        templates{i}=pieceOutline(pieces{i});
    end
end