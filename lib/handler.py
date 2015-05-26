import os, subprocess, shlex, shutil

def runSketch(number, imgPath):
	try:
		if os.environ["SERVER"] == "0":
			SERVER = False
		else:
			SERVER = True
		print "SERVER?",SERVER
	except:
		return False

	currDir = os.getcwd()
	if not SERVER:
		sketchDir = "lib/testSketch/" 
	else:
		sketchDir = "lib/testSketch/application.linux64/"
	print sketchDir,"sd"
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
	if SERVER:
		args = os.path.join(sketchDir,"testSketch")
	else:
		cmd = "processing-java --sketch="+sketchPath+" --output="+outputPath+" --force --run"
		args = shlex.split(cmd)

	p = subprocess.call(args)

	# Print exit code
	print p
	if p == 0:
		# move the image into static/img/
		imgSrc = os.path.join(sketchPath,"test.jpg")
		shutil.move(imgSrc,imgPath)
		return True
	else:
		return False
