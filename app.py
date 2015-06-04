import os, datetime
from flask import Flask, request, render_template
import lib.handler as handler

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        dotsPerRow = request.form['dotsPerRow']
        dotRadius = request.form['dotRadius']
        dotRadiusMin = request.form['dotRadiusMin']
        dotRadiusMax = request.form['dotRadiusMax']
        dotDist = request.form['dotDist']
        dotOffsetMax = request.form['dotOffsetMax']
        strokeWeight = request.form['strokeWeight']

        fill = request.form['fill']
        uFill = True if fill == "True" else False 

        dotRadiusRandomize = request.form['dotRadiusRandomize']
        uDotRadiusRandomize = True if dotRadiusRandomize == "True" else False 

        dotCenterRandomize = request.form['dotCenterRandomize']
        uDotCenterRandomize = True if dotCenterRandomize == "True" else False 

        stroke = request.form['stroke']
        uStroke = True if stroke == "True" else False 

    	try:
            uDotsPerRow = int(dotsPerRow)
            uDotRadius = float(dotRadius)
            uDotRadiusMin = float(dotRadiusMin)
            uDotRadiusMax = float(dotRadiusMax)
            uDotDist = float(dotDist)
            uDotOffsetMax = float(dotOffsetMax)
            uStrokeWeight = float(strokeWeight)
        except:
            return render_template('index.html',img="",errors="Invalid input, please enter a number between 1-1000")

        # Create settings dict
        settings = {"dotsPerRow":uDotsPerRow,
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

        # Create some sort of unique image path
        imgPath = "static/img/"+str(datetime.datetime.now())+".jpg"

        # Run the sketch
        runResult = handler.runSketch(settings,imgPath, "dots1")
    	if not runResult:
            return render_template('index.html',img="",errors="Unable to process sketch.")
        else:
            return render_template('index.html',img=imgPath,errors="")
    else:
        return render_template('index.html',img="",errors="")
if __name__ == "__main__":
    app.run(debug=True)
