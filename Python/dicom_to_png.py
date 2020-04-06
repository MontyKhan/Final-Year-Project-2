import matlab.engine

def dicom_to_png():
	eng = matlab.engine.start_matlab()
	eng.dicom_to_png('D:\Coursework\Final-Year-Project-2\Central slices\DICOM\Chester Mosley_Control.dcm', nargout=0)

dicom_to_png()