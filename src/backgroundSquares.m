function highlight_index=backgroundSquares(squares)

    background_colors=[];
    for i=1:length(squares)

        c_piece=squares{i};

        piece_grey=rgb2gray(c_piece);

        % crop out edge detection errors
        pad=2;
        c_piece=piece_grey(pad:end-pad,pad:end-pad);

        % generate histogram of pixel values
        h=imhist(c_piece,255);

        % most frequently occuring value is the background pixel value
        [~,back]=max(h);
        
        % add squares background color to a list
        background_colors=[background_colors back];
    end

    % get 2 background colors
    c1=mode(background_colors);
    background_colors(background_colors==c1)=NaN;
    c2=mode(background_colors);
    background_colors(background_colors==c2)=NaN;
    
    
    % if no highlighted squares found, it is the start of the game and it is
    % white to move
    if all(isnan(background_colors))
        highlight_index=0;
        return
    end

    % highlighted squares are different than the rest
    highlight_index=find(~isnan(background_colors));
    if length(highlight_index)~=2
        error('less than 2 highlighted squares');
    end

end