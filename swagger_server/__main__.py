#!/usr/bin/env python3

import connexion
from flask_cors import CORS
import logging

from swagger_server import encoder
from swagger_server import config


def main():
    app = connexion.App(__name__, specification_dir='./swagger/')
    app.app.json_encoder = encoder.JSONEncoder
    app.add_api('swagger.yaml', arguments={'title': 'DDI Converter Tool'}, pythonic_params=True)
    logging.basicConfig(filename=config.DDI_CONVERTER_TOOL_LOG_FILE, level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

    # add CORS support
    CORS(app.app)
    app.run(port=8520, debug=config.DDI_CONVERTER_TOOL_DEBUG, threaded=True)

if __name__ == '__main__':
    main()
