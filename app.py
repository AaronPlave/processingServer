import os, datetime, json, random, string
from flask import Flask, request, render_template, url_for
import lib.handler as handler
from werkzeug.contrib.cache import SimpleCache
from PIL import Image
from io import BytesIO
import base64


from werkzeug.contrib.cache import MemcachedCache
dotCache = MemcachedCache(['127.0.0.1:11211'])

# Initialize dotCache if necessary
if dotCache.get("allSketches") is None:
    dotCache.set("allSketches",{},99999999)  

app = Flask(__name__)




# @app.route('/dotsV2/submit', methods=['GET'])
# def dotsV2Submit():
#     if request.method == 'GET':
#         print request.args
#         dotsPerRow = request.args.get('dotsPerRow')
#         numIters = request.args.get('numIters')
#         dotRadius = request.args.get('dotRadius')
#         dotRadiusMin = request.args.get('dotRadiusMin')
#         dotRadiusMax = request.args.get('dotRadiusMax')
#         dotDist = request.args.get('dotDist')
#         dotOffsetMax = request.args.get('dotOffsetMax')
#         strokeWeight = request.args.get('strokeWeight')

#         fill = request.args.get('fill')
#         uFill = True if fill == "true" else False 

#         dotRadiusRandomize = request.args.get('dotRadiusRandomize')
#         uDotRadiusRandomize = True if dotRadiusRandomize == "true" else False 

#         dotCenterRandomize = request.args.get('dotCenterRandomize')
#         uDotCenterRandomize = True if dotCenterRandomize == "true" else False 

#         stroke = request.args.get('stroke')
#         uStroke = True if stroke == "true" else False 

#         try:
#             uDotsPerRow = int(dotsPerRow)
#             uNumIters = int(numIters)
#             uDotRadius = float(dotRadius)
#             uDotRadiusMin = float(dotRadiusMin)
#             uDotRadiusMax = float(dotRadiusMax)
#             uDotDist = float(dotDist)
#             uDotOffsetMax = float(dotOffsetMax)
#             uStrokeWeight = float(strokeWeight)
#         except:
#             return render_template('dotsV2.html',img="",errors="Invalid input, please enter a number between 1-1000")

#         # Create settings dict
#         settings = {"dotsPerRow":uDotsPerRow,
#                     "numIters":uNumIters,
#                     "fill":uFill,
#                     "stroke":uStroke,
#                     "strokeWeight":uStrokeWeight,
#                     "dotRadiusRandomize":uDotRadiusRandomize,
#                     "dotCenterRandomize":uDotCenterRandomize,
#                     "dotOffsetMax":uDotOffsetMax,
#                     "dotRadius":uDotRadius,
#                     "dotRadiusMin":uDotRadiusMin,
#                     "dotRadiusMax":uDotRadiusMax,
#                     "dotDist":uDotDist
#                     }
#         print settings

#         # Create some sort of unique image path
#         imgPath = "static/img/"+str(datetime.datetime.now())+".jpg"

#         # Run the sketch
#         runResult = handler.runSketch(settings,imgPath, "dots2")
#         if not runResult:
#             return json.dumps({"img":""})
#         else:
#             return json.dumps({"img":imgPath})

# @app.route('/dotsV2', methods=['GET'])
# def dotsV2():
#     return render_template('dotsV2.html')

@app.route('/')
def landingPage():
    return render_template('landing.html')

@app.route('/dotsGallery',methods=['GET'])
def dotsGallery():
    rv = dotCache.get("allSketches")
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
        # Add individual entry
        rId = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(7))
        dotCache.set(rId,request.json.get("opts"),99999999)

        # Create and save thumbnail
        thumbnail = request.json.get("img")

        # Add to global list.
        allSketches = dotCache.get("allSketches")
        allSketches[rId] = thumbnail
        dotCache.set("allSketches",allSketches,99999999)
        return str(rId)

@app.route('/dotsGenerator/<idx>')
def dotsV3GetSketch(idx):
    rv = dotCache.get(idx)
    if rv is None:
        return render_template('dotsGenerator.html',error="Unable to fetch requested sketch.",sharedOpts="")
    return render_template('dotsGenerator.html',error="",sharedOpts=json.dumps({"data":rv}))

# def dataURIToImage(uri,filepath):
#     """
#     Converts the URI to png, resizes, and saves to filepath
#     """
#     data = uri.split("base64,")[1]
#     im = Image.open(BytesIO(base64.b64decode(data)))

#     # Crop to center
#     halfWidth = im.size[0] / 2
#     halfHeight = im.size[1] / 2

#     if (halfHeight < 150) or (halfWidth < 150):
#         basewidth = 300
#         wpercent = (basewidth/float(im.size[0]))
#         hsize = int((float(img.size[1]) * float(wpercent)))
#         im = im.resize((basewidth,hsize),PIL.Image.ANTIALIAS)

#     imCrop = im.crop(halfWidth - 150,halfHeight - 150,halfWidth+150,halfHeight+150)
#     imCrop.save(filepath)
#     return True

if __name__ == "__main__":
    app.run(debug=True,threaded=True)

