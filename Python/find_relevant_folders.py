import os
import shutil
import pydicom

def str_join(*args):
    return ''.join(map(str, args))

def identify_data():
	# Set filepaths
	dataset = os.fsencode('D:\CT study Georgia Breen')
	key_path = 'D:\Coursework\Final-Year-Project-2\Central slices\Categories.csv'

	# First, open key and create array of data
	key = []
	with open(key_path) as fp:
		line = fp.readline()
		while (line):
			row = line.split(',')
			row[-1] = row[-1].replace('\n','')	# Remove '\n' from last item in row
			key.append(row)
			line = fp.readline()

	count = 0

	# Then iterate through medical imaging directory
	for patient in os.listdir(dataset):
		filename = os.fsdecode(patient)

		# Search through key for patient info
		n = len(key)
		ckcs = False
		patient_name = ""
		affected = ""
		for i in range(n):
			name = key[i][0][:-1]			# Excel sheet has spaces after some names
			if name.lower() in filename.lower():	# Put all in lower case
				affected = key[i][9]
				patient_name = name
				ckcs = True
			else:
				continue
		
		# If patient isn't in key, then they're not a CKCS so move on.
		if (ckcs == False):
			continue

		if (affected == '1'):
			category = "affected"
		else:
			category = "control"	

		check_if_valid(filename, category)

	print('\nFinished!')

def check_if_valid(filename, category):
	print(filename)

	filepath = os.path.join("D:\CT study Georgia Breen", filename)	
	file_list = os.listdir(filepath)

	dicom_list = []
	central_slice = []

	# Check if folder contains subfolders, if so call function recursively
	count = 0
	for file in file_list:
		full_name = os.path.join(filepath, file)
		if os.path.isdir(full_name):
			subfolder = os.path.join(filename, file)
			check_if_valid(subfolder, category)
		else:
			# Use only DICOM images
			if not (os.fsdecode(file).endswith('.dcm')):
				continue
			else:
				# Use only images depicting MRI sagittal scans of the brain
				dicom_file = os.path.join(filepath, os.fsdecode(file))
				ds = pydicom.read_file(dicom_file)
				if ('T2 SAG BRAIN' in ds.SeriesDescription) and (ds.Modality == "MR"):
					filename_out = str_join(str(ds.PatientName), '_', category, '_', str(count), '.dcm')
					output_path = os.path.join(mri_path, str(ds.PatientName))

					if not os.path.exists(output_path):
						os.mkdir(output_path);

					output = os.path.join(output_path, filename_out)
					shutil.copy(full_name, output)
					count = count + 1
				else:
					continue

mri_path = 'D:\Coursework\Final-Year-Project-2\MRIs'
identify_data()