import os, datetime
from flask import Flask, request, render_template
import lib.handler as handler

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        text = request.form['text']
    	try:
            userNum = int(text)
        except:
            return render_template('index.html',img="",errors="Invalid input, please enter a number between 1-1000")
        imgPath = "static/img/"+str(datetime.datetime.now())+".jpg"
        runResult = handler.runSketch(userNum,imgPath)
    	if not runResult:
            return render_template('index.html',img="",errors="Unable to process sketch.")
        else:
            return render_template('index.html',img=imgPath,errors="")
    else:
        return render_template('index.html',img="",errors="")
if __name__ == "__main__":
    app.run(debug=True)
