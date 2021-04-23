import connexion
import requests
import os
import lxml.etree as ET
import urllib.request
import zipfile
import logging

from dct_server import config

from pyDataverse.api import Api
from datetime import datetime

api = Api(config.DATAVERSE_BASE_URL)


def convert_ddi(ddi_file, dv_target, api_token, xsl_url, author_name=None, author_affiliation=None, contact_name=None, contact_email=None, subject=None):  # noqa: E501
    """Convert DDI and ingest it to target dataverse

     # noqa: E501

    :param ddi_file: 
    :type ddi_file: strstr
    :param dv_target: The target of dataverse alias or id (e.g. root)
    :type dv_target: str
    :param api_token: Users&#x27; authenication token for the api
    :type api_token: str
    :param xsl_url: XSL URL
    :type xsl_url: str
    :param author_name: Author name
    :type author_name: str
    :param author_affiliation: Author Affiliation
    :type author_affiliation: str
    :param contact_name: Dataset Contact Name
    :type contact_name: str
    :param contact_email: Dataset Contact Email
    :type contact_email: str
    :param subject: Dataset Subject
    :type subject: str

    :rtype: None
    """
    xsl_src = urllib.request.urlopen(xsl_url)
    if xsl_src.getcode() != 200:
        return "NOT FOUND XSL", 404
    xsl = xsl_src.read()
    xsl_content = xsl.decode("utf8")
    xsl_src.close()
    if not xsl:
        return "Empty xsl", 404
    if not is_dataverse_target_exist(dv_target, api_token):
        return "Dataverse Not Fould", 404

    uploaded_file = connexion.request.files['ddi_file']

    if uploaded_file and allowed_file(uploaded_file.filename):
        uploaded_filename = uploaded_file.filename
        dir_name =  create_directory_name()
        os.mkdir(dir_name)

        xsl_content = xsl_content.replace('@TODO-AUTHOR-NAME@', author_name) \
            .replace('@TODO-AUTHOR-AFFILIATION@', author_affiliation) \
            .replace('@TODO-CONTACT-EMAIL@', contact_email) \
            .replace('@TODO-CONTACT-NAME@', contact_name) \
            .replace('@SUBJECT@', subject) \
            .replace('@OUTPUT-DIRECTORY-NAME@',dir_name)

        with open(dir_name + '/converter.xsl', "w") as text_file:
            print(xsl_content, file=text_file)

        uploaded_file.save(os.path.join(dir_name, uploaded_filename))

        xml_file = dir_name + '/' + uploaded_filename
        logging.debug('xml_file: ' + xml_file)
        dom = ET.parse(xml_file)
        xsl_file = dir_name + '/converter.xsl'
        xslt = ET.parse(xsl_file)
        transform = ET.XSLT(xslt)
        newdom = transform(dom)
        if not newdom:
            return "Error during transformation.", 500
        # #
        dataset_json = content(dir_name + '/dataset.json')
        #dv_resp = api.create_dataset(dv_target, dataset_json)
        # Replace pyDatavere with direct metadata deposit
        headers = {'X-Dataverse-key': api_token}
        headers_file = {
        'X-Dataverse-key': api_token,
        }
        dataset_json = content(dir_name + '/dataset.json')
        dv_resp = requests.post(
                    config.DATAVERSE_BASE_URL + '/api/dataverses/' + dv_target + '/datasets',
                    data=dataset_json, headers=headers)

        logging.debug(dv_resp.status_code)
        if dv_resp.status_code != 201:
            return "ERROR, the response code isn't 201", dv_resp.status_code

        identifier = dv_resp.json()['data']['persistentId']
        logging.debug(identifier)

        logging.debug('creating archive of ' + dir_name)
        zf = zipfile.ZipFile(dir_name + '/dataset-files.zip', mode='w')
        files_to_upload = os.listdir(dir_name)
        print(files_to_upload)
        try:
            for file_to_upload in files_to_upload:
                logging.debug ('adding ' + dir_name + '/' + file_to_upload)
                if file_to_upload not in  ['dataset-files.zip', 'dataset.json', 'converter.xsl']:
                    zf.write(dir_name + '/' + file_to_upload)

        finally:
            print ('closing')
            zf.close()
        logging.debug(zf.infolist())
        upload_files_resp = api.upload_file(identifier, dir_name + '/dataset-files.zip')
        logging.debug(upload_files_resp)
        return "Upload success", 201
    else:
        return "ERROR", 404


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in config.ALLOWED_EXTENSIONS


def content(filepath):
    text = open(filepath, 'r+')
    content = text.read()
    text.close()
    content = content.replace('\n', '')
    return content.encode("utf-8")

def is_dataverse_target_exist(dataverse_alias_or_id, api_token):
    api.api_token=api_token
    # Let's assume it does exist, check ToDo
    return True

    print("api.api_token: " + api.api_token)
    resp = api.get_dataverse(dataverse_alias_or_id, api_token)
    if resp.status_code == 200:
        return True

    print(resp.status_code)

    return False

def create_directory_name():
    now = datetime.now()
    return config.TEMPORARY_DIRECTORY + '/' + now.strftime("%Y-%m-%d_%H%M%S.%f")


