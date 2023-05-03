from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "App is Working ! - Kashyap Rathore"

@app.route('/api/tasks')
def tasks():
    return "App is Working ! - Kashyap Rathore!!!"


