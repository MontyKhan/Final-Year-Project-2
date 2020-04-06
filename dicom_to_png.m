function dicom_to_png(input)

    output = '.\Central slices\Images\';
    dataset = dir(input);

    for n = 3:length(dataset)
        dicom = dataset(n).name;
        info = dicominfo(fullfile(input,dicom));
        image = uint16(dicomread(info));
        name = erase(dicom,'.dcm');

        filename = strcat(output, name,'.png');
        imwrite(mat2gray(image),filename);
    end
end

