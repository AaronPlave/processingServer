import os, datetime, json, random, string, base64
from flask import Flask, request, render_template, url_for
import lib.handler as handler
import lib.db as db
from PIL import Image
from io import BytesIO

app = Flask(__name__)

@app.route('/')
def landingPage():
    return render_template('landing.html')

@app.route('/dotsGallery',methods=['GET'])
def dotsGallery():
    rv = db.getAllSketches()
    if rv is None:
        return render_template('dotsGallery.html',error="Unable to fetch sketches.")
    return render_template('dotsGallery.html',error="",dotSketches=rv)

@app.route('/dotsGenerator/')
def dotsGenerator():
    return render_template('dotsGenerator.html')

@app.route('/dotsGenerator/publish', methods=['POST'])
def dotsGeneratorPostPublish():
    # Submit, return OK if all good.
    if request.method == 'POST':
        # Create random id
        rId = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(7))

        # Pull out image
        thumbnailURI = request.json.get("img")
        filepath = "static/imgs/"+rId+".png"
        dataURIToImage(thumbnailURI,filepath)
        # Add sketch to db
        if not db.addSketch(rId,request.json.get("opts"),filepath):
            print "ERROR: Could not add sketch", rId
            return False

        return rId

@app.route('/dotsGenerator/<idx>')
def dotsV3GetSketch(idx):
    rv = db.getSketchById(idx)
    if rv.get("success"):
        sketch = rv.get("data").get("sketch")
        # Remove the thumbnail, don't need to send it here
        return render_template('dotsGenerator.html',error="",sharedOpts=json.dumps({"data":sketch}))
    print "ERROR: Unable to fetch sketch", idx
    return render_template('dotsGenerator.html',error="Unable to fetch requested sketch.",sharedOpts="")

def dataURIToImage(uri,filepath):
    """
    Converts the URI to png, resizes, and saves to filepath
    """
    data = uri.split("base64,")[1]
    im = Image.open(BytesIO(base64.b64decode(data)))

    # Crop to center
    # halfWidth = im.size[0] / 2
    # halfHeight = im.size[1] / 2

    # if (halfHeight < 150) or (halfWidth < 150):
    #     basewidth = 300
        # wpercent = (basewidth/float(im.size[0]))
        # hsize = int((float(im.size[1]) * float(wpercent)))
        # im = im.resize((basewidth,hsize),Image.ANTIALIAS)

    # imCrop = im.crop((halfWidth - 150,halfHeight - 150,halfWidth+150,halfHeight+150))
    im.save(filepath)
    return True

if __name__ == "__main__":
    app.run(debug=True,threaded=True)

