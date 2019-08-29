import connexion
import six
import os
import lxml.etree as ET
import json
import xmltodict

from pyDataverse.api import Api
from pyDataverse.models import Dataverse
from datetime import datetime

from swagger_server import util

ALLOWED_EXTENSIONS = {'xml'}
base_url='http://ddvn.dans.knaw.nl:8080'
api = Api(base_url)


# TODO: Using config.py



def convert_ddi(ddi_file, dv_target, api_token, author_name, author_affiliation, contact_name, contact_email):  # noqa: E501
    """Convert DDI and ingest it to target dataverse

     # noqa: E501

    :param ddi_file: 
    :type ddi_file: strstr
    :param dv_target: The target of dataverse alias or id (e.g. root)
    :type dv_target: str
    :param api_token: Users&#x27; authenication token for the api
    :type api_token: str
    :param author_name: Author name
    :type author_name: str
    :param author_affiliation: Author Affiliation
    :type author_affiliation: str
    :param contact_name: Dataset Contact Name
    :type contact_name: str
    :param contact_email: Dataset Contact Email
    :type contact_email: str

    :rtype: None
    """
    if not is_dataverse_target_exist(dv_target, api_token):
        return "Dataverse Not Fould", 404

    uploaded_file = connexion.request.files['file_name']
    if uploaded_file and allowed_file(uploaded_file.filename):
        uploaded_filename = add_file_suffic(uploaded_file.filename)
        uploaded_file.save(os.path.join('/Users/akmi/eko-temp', uploaded_filename))
        x = content(uploaded_filename)
        print(x)

        dom = ET.parse("/Users/akmi/eko-temp/" + uploaded_filename)
        xslt = ET.parse("/Users/akmi/eko-temp/convert-ddi.xsl")
        transform = ET.XSLT(xslt)
        newdom = transform(dom)
        xmlString = ET.tostring(newdom, pretty_print=True).decode('utf-8')
        print(xmlString)
        # Based on https://stackoverflow.com/questions/26726728/remove-namespace-with-xmltodict-in-python
        # So, I will remove it from xmlString.  Not ideal.
        xmlString = xmlString.replace('xmlns:ddi="ddi:instance:3_1"','') \
            .replace('xmlns:r="ddi:reusable:3_1"','') \
            .replace('xmlns:dc="ddi:dcelements:3_1"','') \
            .replace('xmlns:dc2="http://purl.org/dc/elements/1.1/"','') \
            .replace('xmlns:s="ddi:studyunit:3_1"','') \
            .replace('xmlns:c="ddi:conceptualcomponent:3_1"','') \
            .replace('xmlns:d="ddi:datacollection:3_1"','') \
            .replace('xmlns:l="ddi:logicalproduct:3_1"','') \
            .replace('xmlns:p="ddi:physicaldataproduct:3_1"','') \
            .replace('xmlns:pi="ddi:physicalinstance:3_1"','') \
            .replace('xmlns:a="ddi:archive:3_1"','')
        xmlString = xmlString.replace('@TODO-AUTHOR-NAME@','Indarto, Eko')
        print(xmlString)

        datasetJson = json.dumps(xmltodict.parse(xmlString), indent=0)
        print("\nJSON output(output.json):")
        print(datasetJson)
        eko = datasetJson.replace('"false"','false').replace('"true"','true').replace(',\nnull','')
        print('--begin---')
        print(eko)
        print('--end---')
        # #
        # y = content('dataset_min.json').encode("utf-8")
        # print(y)
        z = ingest_dataset(dv_target, eko, api_token)
        print("ingest result:")
        print(z)
        return "Upload success", 201
    else:
        return "ERROR", 404


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def content(filename):
    text = open('/Users/akmi/eko-temp/' + filename , 'r+')
    content = text.read()
    text.close()
    return content

def is_dataverse_target_exist(dataverse_alias_or_id, api_token):
    api.api_token=api_token
    print("api.api_token: " + api.api_token)
    resp = api.get_dataverse(dataverse_alias_or_id, api_token)
    if resp.status_code == 200:
        return True

    print(resp.status_code)

    return False

def ingest_dataset(dataverse_target, jsondataset, api_token):
    resp = api.create_dataset(dataverse_target, jsondataset)
    print(resp)
    return resp.status_code

def add_file_suffic(filename):
    now = datetime.now()
    return filename.rsplit('.', 1)[0] + now.strftime("_%Y-%m-%d_%H%M%S.%f.") + filename.rsplit('.', 1)[1]
