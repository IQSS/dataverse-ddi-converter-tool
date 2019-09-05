# DDI to Dataverse converter tool
This tool developed as a part of SSHOC Dataverse project by the international team from EU. We used pyDataverse module created by AUSSDA to deposit datasets metadata and files to Dataverse.

The main idea of the project is to separate mappings from the conversion process and let metadata specialist to do it separately from the DDI migration process. The tool has Docker infrastructure that allows to deploy it on Kubernetes and other Cloud platforms. 

## Overview
This server was generated by the [swagger-codegen](https://github.com/swagger-api/swagger-codegen) project. 
![Swagger demo](https://github.com/IQSS/dataverse-ddi-converter-tool/raw/master/manual/swagger.png)

You need to upload DDI file, select a proper mapping from the external URL like github, create subdataverses in your Dataverse repository and generate API token. DDI converter will do the automatic migration of Study metadata to Dataverse metadata and create files on variables level extracted from DDI. 

![Swagger demo](https://github.com/IQSS/dataverse-ddi-converter-tool/raw/master/manual/swaggerupload.png)

A lot of DDI mappings for your inspiration available here: https://github.com/MetadataTransform/ddi-xslt

## How to generate Swagger:
````
swagger-codegen generate -c dct-swagger-codegen-config.json -i ddi-converter-tool.yaml -l python-flask  -o .
````


## Requirements
Python 3.5.2+

## Usage
To run the server, please execute the following from the root directory:

```
pip3 install -r requirements.txt
pip3 install --no-cache-dir -r requirements.txt
pip3 install "connexion[swagger-ui]"

pip3 install connexion[swagger-ui]
Note: 
When the result something like 'zsh: no matches found: connexion[swagger-ui]'
Solution:
pip3 install "connexion[swagger-ui]"

pip3 install flask-debugtoolbar
pip3 install flask_cors
pip3 setup.py
pip3 install lxml
pip3 install xmltodict
pip3 install pyDataverse

python3 -m dct_server --reload
```

and open your browser to here:

```
http://localhost:8520/api/ui/
```

Your Swagger definition lives here:

```
http://localhost:8520/api/swagger.json
```

To launch the integration tests, use tox:
```
sudo pip install tox
tox
```

## Running with Docker

To run the server on a Docker container, please execute the following from the root directory:

```bash
# building the image
docker build -t dct_server .

# starting up a container
docker run -p 8520:8520 dct_server
```

swagger-codegen generate -i ddi-converter-tool.yaml -l python-flask  -o .

Notes: 
Since python does not have any equivalent of interfaces like in java, 
so the implementation of controller is written in default_controller.py.
It means that the default_controller.py needs to add in .swagger-codegen-ignore file.

For SSHOC image:
docker build -t sshoc/ddi-converter-tool .
docker run -d -it -p 8520:8520 --name dct_server sshoc/ddi-converter-tool









```
curl -X POST "http://127.0.0.1:8520/api/convert/ekoi/c89e6f53-9edc-4a73-9ff5-4447e6911f2b?xsl_url=https%3A%2F%2Fraw.githubusercontent.com%2Fekoi%2Fddi-converter-tool%2Fmaster%2Fxsl%2Fddi-to-dataset-csv.xsl&author_name=Indarto%2C%20E&author_affiliation=DANS&contact_name=Indarto%2C%20Eko&contact_email=eko.indarto%40dans.knaw.nl&subject=Medicine%2C%20Health%20and%20Life%20Sciences" -H "accept: */*" -H "Content-Type: multipart/form-data" -F "ddi_file=@SSI-ddi3.xml;type=text/xml"
```

