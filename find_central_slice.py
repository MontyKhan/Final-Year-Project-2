import os
import shutil
import pydicom

def str_join(*args):
    return ''.join(map(str, args))

dataset = os.fsencode('D:\CT study Georgia Breen')
output = 'D:\Coursework\Final-Year-Project-2\Central slices'

for patient in os.listdir(dataset):
	filename = os.fsdecode(patient)
	filepath = os.path.join("D:\CT study Georgia Breen", filename)

	if (os.path.isdir(filepath)) and filename.endswith('MRI'):
		print(os.fsdecode(patient))
		file_list = os.listdir(filepath)

		if filename in file_list:
			filepath = os.path.join(filepath, filename)
			file_list = os.listdir(filepath)

		dicom_list = []

		for file in file_list:
			if not (os.fsdecode(file).endswith('.dcm')):
				continue
			else:
				dicom_file = os.path.join(filepath, os.fsdecode(file))
				ds = pydicom.read_file(dicom_file)
				if (ds.SeriesDescription == 'T2 SAG BRAIN'):
					dicom_list.append(file)
				else:
					continue

		median = int(len(dicom_list)/2) + 1
		print(median)
		print(dicom_list[median])
		central_slice = os.path.join(filepath, dicom_list[median])
		shutil.copy(central_slice, output)
	else:
		continue

print('\nFinished!')