import os, datetime
from flask import Flask, request, render_template
import lib.handler as handler

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        dotsPerRow = request.form['dotsPerRow']
        fill = request.form['fill']
        if fill == "True":
            uFill = True
        else:
            uFill = False
    	try:
            uDotsPerRow = int(dotsPerRow)
        except:
            return render_template('index.html',img="",errors="Invalid input, please enter a number between 1-1000")

        # Create settings dict
        settings = {"dotsPerRow":uDotsPerRow,
                    "fill":uFill}

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
