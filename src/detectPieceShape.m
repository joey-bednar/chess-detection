% detect piece shape from the outline
function shape=detectPieceShape(piece)

    % check if square is empty
    light=sum(piece==1,'all');
    area=size(piece,1)*size(piece,2);
 
    % square is empty if it has very few white pixels
    if light/area<0.01
        shape=0; % indicates empty square
        return
    end

    % load piece templates
    load('templates');

    ccor_list=[];
    for i=1:length(templates)

        % resize template to size of piece
        dims_piece=size(piece);
        x=imresize(templates{i},dims_piece);


        % compute maximum of 2d cross correlation
        ccor=normxcorr2(x,piece);
        ccor_max=max(ccor,[],'all');
        
        % add value to list
        ccor_list=[ccor_list ccor_max];
        

%         orient=regionprops(piece,'Orientation').Orientation;
%         orient=min(abs(orient),abs(abs(orient)-90));
% 
%         peri=regionprops(x,'Perimeter').Perimeter;
%         perip=regionprops(piece,'Perimeter').Perimeter;
% 
%         disp([ccor_max,orient,peri,perip])
    end
    
    [~,max_i]=max(ccor_list);
    piece_i = mod(max_i,6);
    
    if piece_i==1
        shape='p';
    elseif piece_i==2
        shape='r';
    elseif piece_i==3
        shape='n';
    elseif piece_i==4
        shape='b';
    elseif piece_i==5
        shape='q';
    else
        shape='k';
    end
    
end