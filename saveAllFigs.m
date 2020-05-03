currentFigs = findall(groot, 'Type', 'Figure');

n = length(currentFigs);

for i = 1:n   
    filename = strcat('D:\Coursework\Final-Year-Project-2\Data\SVM\graph_', num2str(i), '.png');
    saveas(currentFigs(i), filename);
end