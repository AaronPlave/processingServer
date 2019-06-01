import pymongo
from PIL import Image
from io import BytesIO

client = pymongo.MongoClient()
db = client["dots"]
SKETCHES = db["sketches"]
ALL_SKETCHES = db["allSketches"]

def getSketchById(id):
	sketch = SKETCHES.find({"id":id})
	if sketch.count() == 1:
		target = sketch[0]
		return {"success":True,"data":target}
	elif sketch.count() == 0:
		return {"success":False,"error":"No sketch found for given id"}
	else:
		print "ERROR: Duplicate sketches for",id
		return {"success":False,"error":"Multiple sketches with same id"}

def getAllSketches():
	allSketches = SKETCHES.find({},{"sketch":0,"_id":0})
	if allSketches.count() == 0:
		return [{}]
	return list(allSketches)

def convertAll():
	allSketches = SKETCHES.find()
	for i in allSketches:
		thb = i["thumbnail"]
		rId = i["id"]
		filepath = "static/imgs/"+rId+".png"
		data = thb.split("base64,")[1]
		try:
			im = Image.open(BytesIO(base64.b64decode(data)))
			im.save(filepath)
		except:
			print "NOOOO", rId
		if not filepath:
			print "UH NO",rId
			return

		SKETCHES.update(
			{"id":rId},
			{
				"$set":{
					"thumbnail":filepath
				}
			}
		)


def addSketch(id,sketch,thumbnail):
	try:
		add = SKETCHES.insert({"id":id, "sketch": sketch, "thumbnail": thumbnail})
		return True if add else False
		# allSketches = ALL_SKETCHES.find()
		# data = {id:thumbnail}
		# if allSketches.count() == 0:
		# 	ALL_SKETCHES.insert({"id":"allSketches","allSketches":data})
		# else:
		# 	oldSketches = allSketches[0]["allSketches"]
		# 	oldSketches[id] = thumbnail
			# ALL_SKETCHES.update({"id":"allSketches"},{"$set": {"id":"allSketches","allSketches":oldSketches}}, upsert=True)
	except Exception, e:
		print "ERROR: Could not insert"
		print e
		return False