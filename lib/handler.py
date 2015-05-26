import os, subprocess, shlex, shutil

def runSketch(number, imgPath):
	currDir = os.getcwd()
	sketchDir = "lib/testSketch/"
	sketchPath = os.path.join(currDir,sketchDir)
		
	outputDir = "lib/tmp/"
	outputPath = os.path.join(currDir,outputDir)

	settingsFileName = "settings.txt"
	settingsFilePath = os.path.join(sketchPath,settingsFileName)

	# Create the settings file
	f = open(settingsFilePath,"w")
	f.write(str(number))
	f.close()

	# Create the processing os process
	args = shlex.split("processing-java --sketch="+sketchPath+" --output="+outputPath+" --force --run")
	p = subprocess.call(args)

	# Print exit code
	print p
	if p == 0:
		imgSrc = os.path.join(sketchPath,"test.jpg")
		shutil.move(imgSrc,imgPath)
		return True
	else:
		return False
