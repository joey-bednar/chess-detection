% given 8x8 array board, create FEN string that will
% be used for chess engine analysis
% color specifies whose move it is in the position
% White: w, Black: b
function fen=generateFEN(board,color,en_passant)

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
    
    % if rooks/king are in castling position, assume that the king and
    % rooks have not moved. This is used to determine if castling is
    % possible.
    castle='-';
    if char(board(8,8))=='R' && char(board(8,5))=='K'
    castle=[castle 'K'];
    end
    if char(board(8,1))=='R' && char(board(8,5))=='K'
        castle=[castle 'Q'];
    end
    if char(board(1,8))=='r' && char(board(1,5))=='k'
        castle=[castle 'k'];
    end
    if char(board(1,1))=='r' && char(board(1,5))=='k'
        castle=[castle 'q'];
    end

    if length(castle)>1
        castle=castle(2:end);
    end

    % assumptions:
    % - image is from white's perspective
    % - if rooks/king are in correct position, assume castling is possible
    % - en passant is not a legal move
    % - fifty-move rule unimportant
    fen=fen+" "+color+" "+castle+" "+en_passant+" 0 1";
    %fen=fen+" w KQkq - 0 1";

end