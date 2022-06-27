%% Generate and save piece templates
clear
clc

% generate templates from image sources
chesscom=generateTemplate('../img/c1.png'); %chess.com template
lichess=generateTemplate('../img/l1.png'); % cburnett
templates=[chesscom lichess];

% save templates to mat file
save('templates','templates');