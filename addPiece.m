% returns board with piece added to square
% ======= piece symbols ========
% king:   k   knight: n
% queen:  q   rook:   r
% bishop: b   pawn:   p
function board=addPiece(board,piece,color,index)

    if color=='w'
       symbol=upper(piece);
   else
       symbol=lower(piece);
   end
   
   col=floor((index-1)/8)+1;
   row=mod(index-1,8)+1;

   board(row,col)=symbol;
    
end