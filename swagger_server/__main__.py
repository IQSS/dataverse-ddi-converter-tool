#!/usr/bin/env python3

import connexion
from flask_cors import CORS
import os

from swagger_server import encoder

UPLOAD_FOLDER = '/Users/akmi/eko-temp'
ALLOWED_EXTENSIONS = {'xml'}
# TODO: Using config.py
def main():
    # APP_ROOT = os.path.dirname(os.path.abspath(__file__))   # refers to application_top
    # APP_STATIC = os.path.join(APP_ROOT, 'upload/temp')
    # print(APP_STATIC)
    app = connexion.App(__name__, specification_dir='./swagger/')
    app.app.json_encoder = encoder.JSONEncoder
    app.add_api('swagger.yaml', arguments={'title': 'DDI Converter Tool'}, pythonic_params=True)
    app.app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
    # add CORS support
    CORS(app.app)
    app.run(port=8520, debug=True)



if __name__ == '__main__':
    main()
