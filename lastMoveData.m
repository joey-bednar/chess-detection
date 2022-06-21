function [tomove,en_passant]=lastMoveData(board,highlight_squares)

    % init results for most common case
    tomove='w';
    en_passant='-';

    % if no moves have been made, it is white's turn and en passant is not
    % possible
    if highlight_squares==0
        return
    end


    % get piece on highlighted squares
    for i=1:2
        col=floor((highlight_squares(i)-1)/8)+1;
        row=mod(highlight_squares(i)-1,8)+1;
        highlight_piece(i)=board(row,col);
    end
    [symbol,ind]=max(highlight_piece);

    % get to starting and ending square
    to_square=highlight_squares(ind);
    if ind==1
        from_square=highlight_squares(2);
    else
        from_square=highlight_squares(1);
    end

    % if highlighted piece is black, white to move
    % if highlighted piece is white, black to move
    if symbol>='A' && symbol<='Z'
        tomove='b';
    end

    % if pawn move was made, check if en passant is possible
    if upper(symbol)=='P'
        
        % convert square index to rows/cols
        to_row=mod(to_square-1,8)+1;
        from_row=mod(from_square-1,8)+1;

        % check if en passant is legal
        if (symbol=='P' && to_row==5 && from_row==7) || (symbol=='p' && to_row==7 && from_row==5)

            % en passant square is between the two move squares
            en_square=mean([to_square from_square]);

            % convert square into coordinates
            en_col=floor((en_square-1)/8)+1;
            en_row=mod(en_square-1,8)+1;

            % convert coordinates into chess notation
            en_passant=[char(en_col+'a'-1) num2str(9-en_row)];
            
        end
    end
end