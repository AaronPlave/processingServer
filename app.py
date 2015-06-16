import os, datetime, json
from flask import Flask, request, render_template
import lib.handler as handler

app = Flask(__name__)

@app.route('/')
def landingPage():
    return render_template('landing.html')

@app.route('/dotsV2/submit', methods=['GET'])
def dotsV2Submit():
    if request.method == 'GET':
        print request.args
        dotsPerRow = request.args.get('dotsPerRow')
        numIters = request.args.get('numIters')
        dotRadius = request.args.get('dotRadius')
        dotRadiusMin = request.args.get('dotRadiusMin')
        dotRadiusMax = request.args.get('dotRadiusMax')
        dotDist = request.args.get('dotDist')
        dotOffsetMax = request.args.get('dotOffsetMax')
        strokeWeight = request.args.get('strokeWeight')

        fill = request.args.get('fill')
        uFill = True if fill == "true" else False 

        dotRadiusRandomize = request.args.get('dotRadiusRandomize')
        uDotRadiusRandomize = True if dotRadiusRandomize == "true" else False 

        dotCenterRandomize = request.args.get('dotCenterRandomize')
        uDotCenterRandomize = True if dotCenterRandomize == "true" else False 

        stroke = request.args.get('stroke')
        uStroke = True if stroke == "true" else False 

        try:
            uDotsPerRow = int(dotsPerRow)
            uNumIters = int(numIters)
            uDotRadius = float(dotRadius)
            uDotRadiusMin = float(dotRadiusMin)
            uDotRadiusMax = float(dotRadiusMax)
            uDotDist = float(dotDist)
            uDotOffsetMax = float(dotOffsetMax)
            uStrokeWeight = float(strokeWeight)
        except:
            return render_template('dotsV2.html',img="",errors="Invalid input, please enter a number between 1-1000")

        # Create settings dict
        settings = {"dotsPerRow":uDotsPerRow,
                    "numIters":uNumIters,
                    "fill":uFill,
                    "stroke":uStroke,
                    "strokeWeight":uStrokeWeight,
                    "dotRadiusRandomize":uDotRadiusRandomize,
                    "dotCenterRandomize":uDotCenterRandomize,
                    "dotOffsetMax":uDotOffsetMax,
                    "dotRadius":uDotRadius,
                    "dotRadiusMin":uDotRadiusMin,
                    "dotRadiusMax":uDotRadiusMax,
                    "dotDist":uDotDist
                    }
        print settings

        # Create some sort of unique image path
        imgPath = "static/img/"+str(datetime.datetime.now())+".jpg"

        # Run the sketch
        runResult = handler.runSketch(settings,imgPath, "dots2")
        if not runResult:
            return json.dumps({"img":""})
        else:
            return json.dumps({"img":imgPath})

@app.route('/dotsV2', methods=['GET'])
def dotsV2():
    return render_template('dotsV2.html')

@app.route('/dotsV3')
def dotsV3():
    return render_template('dotsV3.html')

if __name__ == "__main__":
    app.run(debug=True)
