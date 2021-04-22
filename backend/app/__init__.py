import os
import sqlalchemy
from yaml import load, loader
from flask import Flask

UPLOAD_FOLDER = '/upload_files'
if not os.path.isdir(UPLOAD_FOLDER):
    os.mkdir(UPLOAD_FOLDER)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


from app import routes
