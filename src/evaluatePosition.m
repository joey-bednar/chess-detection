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
    bestmove=out{2};
end