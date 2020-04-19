import os
import shutil

def sort_data():

	# Set path for directory containing files to be sorted
	image_folder = 'D:\Coursework\Final-Year-Project-2\Central slices\Skulls (transformed)'
	
	# Set output directories
	affected_folder = os.path.join(image_folder, 'affected')
	control_folder = os.path.join(image_folder, 'control')

	# Check output directories exist
	if not (os.path.isdir(affected_folder)):
		os.mkdir(affected_folder)
	if not (os.path.isdir(control_folder)):
		os.mkdir(control_folder)

	# Move files to correct directories
	for file in os.listdir(image_folder):
		filename = os.fsdecode(file)
		filepath = os.path.join(image_folder, filename)

		if ('affected' in filename):
			shutil.move(filepath, affected_folder)
		elif ('control' in filename):
			shutil.move(filepath, control_folder)

	print('Finished')

sort_data()