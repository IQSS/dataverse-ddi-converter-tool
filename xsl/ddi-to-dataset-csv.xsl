<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                xmlns:ddi="ddi:instance:3_1"
                xmlns:r="ddi:reusable:3_1"
                xmlns:dc="ddi:dcelements:3_1"
                xmlns:dc2="http://purl.org/dc/elements/1.1/"
                xmlns:s="ddi:studyunit:3_1"
                xmlns:c="ddi:conceptualcomponent:3_1"
                xmlns:d="ddi:datacollection:3_1"
                xmlns:l="ddi:logicalproduct:3_1"
                xmlns:p="ddi:physicaldataproduct:3_1"
                xmlns:pi="ddi:physicalinstance:3_1"
                xmlns:a="ddi:archive:3_1">
    <xsl:output method="text" encoding="UTF-8" indent="yes" name="text"/>
    <xsl:variable name="directory-name" select="'@OUTPUT-DIRECTORY-NAME@'"/>
    <xsl:variable name="delimiter" select="','"/>
    <xsl:key name="field" match="/ddi:DDIInstance/dataDscr/var/*" use="@*/string()"/>
    <!-- variable containing the first occurrence of each field -->
    <xsl:variable name="allFields"
                  select="/ddi:DDIInstance/dataDscr/var/*[generate-id()=generate-id(key('field', @*/string()))]" />

    <xsl:template match="/">
        <xsl:call-template name="metadata-json"/>
        <xsl:call-template name="csv-files"/>
    </xsl:template>
    <xsl:template name="metadata-json">
        <xsl:variable name="dataset-file-name"
                      select="concat($directory-name,'/','dataset.json')" />
        <xsl:result-document href="{$dataset-file-name}" format="text">
            {"datasetVersion": {"metadataBlocks": {"citation": {
            "fields": [
            {
            "value": "<xsl:value-of select="/ddi:DDIInstance/s:StudyUnit/r:Citation/dc:DCElements/dc2:title"/>",
            "typeClass": "primitive",
            "multiple": false,
            "typeName": "title"
            },
            {
            "value": [{
            "authorName": {
            "value": "@TODO-AUTHOR-NAME@",
            "typeClass": "primitive",
            "multiple": false,
            "typeName": "authorName"
            },
            "authorAffiliation": {
            "value": "@TODO-AUTHOR-AFFILIATION@",
            "typeClass": "primitive",
            "multiple": false,
            "typeName": "authorAffiliation"
            }
            }],
            "typeClass": "compound",
            "multiple": true,
            "typeName": "author"
            },
            {
            "value": [{
            "datasetContactEmail": {
            "typeClass": "primitive",
            "multiple": false,
            "typeName": "datasetContactEmail",
            "value": "@TODO-CONTACT-EMAIL@"
            },
            "datasetContactName": {
            "typeClass": "primitive",
            "multiple": false,
            "typeName": "datasetContactName",
            "value": "@TODO-CONTACT-NAME@"
            }
            }],
            "typeClass": "compound",
            "multiple": true,
            "typeName": "datasetContact"
            },
            {
            "value": [{"dsDescriptionValue": {
            "value": "<xsl:value-of select="/ddi:DDIInstance/s:StudyUnit/s:Abstract/r:Content"/>",
            "multiple": false,
            "typeClass": "primitive",
            "typeName": "dsDescriptionValue"
            }}],
            "typeClass": "compound",
            "multiple": true,
            "typeName": "dsDescription"
            },
            {
            "value": ["@SUBJECT@"],
            "typeClass": "controlledVocabulary",
            "multiple": true,
            "typeName": "subject"
            }
            ],
            "displayName": "Citation Metadata"
            }}}}
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="csv-files">
        <xsl:for-each select="/ddi:DDIInstance/dataDscr/var">
            <xsl:variable name="csv-file-name"
                          select="concat($directory-name,'/',@name,'.csv')" />
            <xsl:value-of select="$csv-file-name" />  <!-- Creating  -->
            <xsl:result-document href="{$csv-file-name}" format="text">
                <xsl:for-each select="$allFields">
                    <xsl:if test="local-name()='sumStat'">
                        <xsl:value-of select="@*/string()" />
                        <xsl:if test="following-sibling::sumStat">
                            <xsl:value-of select="$delimiter" />
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
                <xsl:call-template name="variables-value"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="variables-value">

        <xsl:for-each select="$allFields">
            <xsl:if test="local-name()='sumStat'">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="following-sibling::sumStat">
                    <xsl:value-of select="$delimiter" />
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
