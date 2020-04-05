function dicom_to_png(input)

output = '.\Central slices\Images\';

info = dicominfo(input);
image = uint16(dicomread(info));
[filepath,name,ext] = fileparts(input);

filename = strcat(output, name,'.png');
imwrite(mat2gray(image),filename);
end

