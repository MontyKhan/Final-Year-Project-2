import os
import shutil
import pydicom

def str_join(*args):
    return ''.join(map(str, args))

def find_central_slice():
	# Set filepaths
	dataset = os.fsencode('D:\CT study Georgia Breen')
	output_path = 'D:\Coursework\Final-Year-Project-2\Central slices\DICOM'
	key_path = 'D:\Coursework\Final-Year-Project-2\Central slices\Categories.csv'

	# First, open key and create array of data
	key = []
	with open(key_path) as fp:
		line = fp.readline()
		while (line):
			row = line.split(',')
			row[2] = row[2].replace('\n','')
			key.append(row)
			line = fp.readline()

	# Then iterate through medical imaging directory
	for patient in os.listdir(dataset):
		filename = os.fsdecode(patient)
		filepath = os.path.join("D:\CT study Georgia Breen", filename)

		# Use only MRI images, not CT
		if (os.path.isdir(filepath)) and filename.endswith('MRI'):
			print(os.fsdecode(patient))
			file_list = os.listdir(filepath)

			# Check if folder contains subfolders
			if filename in file_list:
				filepath = os.path.join(filepath, filename)
				file_list = os.listdir(filepath)

			dicom_list = []

			# Use only DICOM images depicting sagittal scans of the brain
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

			# Categorise images
			n = len(key)
			name = ""
			category = ""
			for i in range(n):
				if key[i][0] in filepath:
					name = key[i][0]
					category = key[i][2]
				else:
					continue

			# Choose middle image of scan as central slice and copy to new location
			median = int(len(dicom_list)/2) + 1
			print(median)
			print(dicom_list[median])
			central_slice = os.path.join(filepath, dicom_list[median])
			filename_out = str_join(name, '_', category, '.dcm')
			output = os.path.join(output_path, filename_out)
			shutil.copy(central_slice, output)
		else:
			continue

	print('\nFinished!')

find_central_slice()