% ONLY WORKS ON LINUX WITH STOCKFISH INSTALLED
% outputs the best move given an FEN

function bestmove=evaluatePosition(FEN)
    % Runs stockfish 8 in Linux terminal to analyze chess position
    % Loads board position using FEN
    % Computes position and waits 1sec for process to finish
    % Outputs multiple top computer moves
    % Moves filtered to only show best move
    [~,cmdout]=system('( echo "position fen '+FEN+'"; echo "go"; sleep 1 )|stockfish|grep bestmove');
    out=split(cmdout);

    % Throw error if move is not in correct format
    move_chars=split(out{2},'');
    if length(move_chars) ~= 4
        error("There was an error when computing the position with stockfish.")
    end
    
    bestmove = out{2};
end



