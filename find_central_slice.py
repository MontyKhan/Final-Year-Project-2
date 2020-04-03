import os
import shutil

def str_join(*args):
    return ''.join(map(str, args))

dataset = os.fsencode('D:\CT study Georgia Breen')
output = 'D:\Central slices'

for patient in os.listdir(dataset):
	filename = os.fsdecode(patient)
	filepath = os.path.join("D:\CT study Georgia Breen", filename)
	if (os.path.isdir(filepath)) and filename.endswith('MRI'):
		print(os.fsdecode(patient))
		file_list = os.listdir(filepath)
		if filename in file_list:
			filepath = os.path.join(filepath, filename)
			file_list = os.listdir(filepath)
		for file in file_list:
			if not (os.fsdecode(file).endswith('.dcm')):
				file_list.remove(file)
		median = int(len(file_list)/2)
		print(median)
		central_slice = os.path.join(filepath, file_list[median])
		shutil.copy(central_slice, output)
	else:
		continue

print('\nFinished!')