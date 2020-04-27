function dicom_to_png(input)

output = 'D:\Coursework\Final-Year-Project-2\MRIs\Images';
dataset = dir(input);

for n = 3:length(dataset)
    if (dataset(n).isdir())
        dicom_to_png(strcat(dataset(n).folder, '\', dataset(n).name));
    else
        dicom = dataset(n).name;
        info = dicominfo(fullfile(input,dicom));
        image = uint16(dicomread(info));
        name = erase(dicom,'.dcm');
        
        outpath_comp=regexp(dataset(n).name,'\','split');
        filename = outpath_comp(end);
        name_comp=regexp(string(filename),'_','split');
        patient_name = name_comp(1);
        output_path = strcat(output, '\', patient_name, '\');
        
        if ~(isfolder(output_path))
            mkdir(string(output_path));
        end
        
        filename = strcat(output_path, name,'.png');
        imwrite(mat2gray(image),string(filename));
    end
end
end

