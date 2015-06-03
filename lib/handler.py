import os, subprocess, shlex, shutil, csv

def writeSettingsFile(settings, filePath):
	"""
	Writes the key value pairs in settings to 
	a csv file named filePath.
	key1,key2...
	val1,val2...
	"""
	f = open(filePath,"w")
	try:
		writer = csv.writer(f)
		keys = settings.keys()
		writer.writerow(keys)
		writer.writerow([str(settings[i]) for i in settings.keys()])
	finally:
		f.close()

def runSketch(settings, imgPath, sketchName):
	try:
		if os.environ["SERVER"] == "0":
			SERVER = False
		else:
			SERVER = True
		# print "SERVER?",SERVER
	except:
		return False

	currDir = os.getcwd()
	if not SERVER:
		sketchDir = "lib/" + sketchName + "/" 
	else:
		sketchDir = "lib/" + sketchName + "/application.linux64/"

	sketchPath = os.path.join(currDir,sketchDir)
		
	outputDir = "lib/tmp/"
	outputPath = os.path.join(currDir,outputDir)

	settingsFileName = "settings.csv"
	if not SERVER:
		settingsFilePath = os.path.join(sketchPath,settingsFileName)
	else:
		settingsFilePath = settingsFileName

	# Create the settings file
	writeSettingsFile(settings,settingsFilePath)

	# Create the processing os process
	if SERVER:
		args = os.path.join(sketchDir,sketchName)
	else:
		cmd = "processing-java --sketch="+sketchPath+" --output="+outputPath+" --force --run"
		args = shlex.split(cmd)

	p = subprocess.call(args)

	# Print exit code
	# print p
	if p == 0:
		# move the image into static/img/
		if not SERVER:
			imgSrc = os.path.join(sketchPath,"test.jpg")
		else:
			imgSrc = os.path.join(currDir,"test.jpg")
		shutil.move(imgSrc,imgPath)
		return True
	else:
		return False
