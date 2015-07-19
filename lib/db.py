import pymongo

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
	allSketches = ALL_SKETCHES.find({"id":"allSketches"})
	if allSketches.count() == 0:
		return {}
	return allSketches[0].get("allSketches")

def addSketch(id,sketch,thumbnail):
	try:
		add = SKETCHES.insert({"id":id, "sketch": sketch, "thumbnail": thumbnail})
		allSketches = ALL_SKETCHES.find()
		data = {id:thumbnail}
		if allSketches.count() == 0:
			ALL_SKETCHES.insert({"id":"allSketches","allSketches":data})
		else:
			oldSketches = allSketches[0]["allSketches"]
			oldSketches[id] = thumbnail
			ALL_SKETCHES.update({"id":"allSketches"},{"$set": {"id":"allSketches","allSketches":oldSketches}}, upsert=True)
	except Exception, e:
		print "ERROR: Could not insert"
		print e
	if not add:
		return False
	return True