import os, datetime
from flask import Flask, request, render_template
import lib.handler as handler

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        dotsPerRow = request.form['dotsPerRow']
        dotRadius = request.form['dotRadius']
        dotDist = request.form['dotDist']

        fill = request.form['fill']
        uFill = True if fill == "True" else False 

        dotRadiusRandomize = request.form['dotRadiusRandomize']
        uDotRadiusRandomize = True if dotRadiusRandomize == "True" else False 

        stroke = request.form['stroke']
        uStroke = True if stroke == "True" else False 

    	try:
            uDotsPerRow = int(dotsPerRow)
            uDotRadius = float(dotRadius)
            uDotDist = float(dotDist)
        except:
            return render_template('index.html',img="",errors="Invalid input, please enter a number between 1-1000")

        # Create settings dict
        settings = {"dotsPerRow":uDotsPerRow,
                    "fill":uFill,
                    "stroke":uStroke,
                    "dotRadiusRandomize":uDotRadiusRandomize,
                    "dotRadius":uDotRadius,
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
