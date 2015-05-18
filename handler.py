import os, subprocess, shlex

def runSketch(number):
	currDir = os.getcwd()
	sketchDir = "testSketch/"
	sketchPath = os.path.join(currDir,sketchDir)
		
	outputDir = "tmp/"
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

runSketch(100)