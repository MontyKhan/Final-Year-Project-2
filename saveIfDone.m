function stop = saveIfDone(info, n)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if strcmp(info.State,'done')
    currentFig = findall(groot, 'Type', 'Figure');
    filename = strcat('D:\Coursework\Final-Year-Project-2\Data\graph_', num2str(n), '.png');
    saveas(currentFig(1), filename);
end

stop = false;

end