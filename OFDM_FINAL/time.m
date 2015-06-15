% This function plots the time domain response
function []= time(inp,titled,col)
    stem(inp,col);
    title(titled);
    xlabel('index');
    ylabel('amplitude');
    axis tight;
end