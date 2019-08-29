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
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <datasetVersion>
            <metadataBlocks>
            <xsl:call-template name="citation"/>
            </metadataBlocks>
        </datasetVersion>    
    </xsl:template>
    <xsl:template name="citation">
        <citation>
            <xsl:call-template name="title"/>
            <xsl:call-template name="author"/>
            <xsl:call-template name="contact"/>
            <xsl:call-template name="description"/>
            <xsl:call-template name="diciplines"/>
            <displayName>Citation Metadata</displayName>
        </citation>
    </xsl:template>
    <xsl:template name="title">
        <fields>
            <value><xsl:value-of select="/ddi:DDIInstance/s:StudyUnit/r:Citation/dc:DCElements/dc2:title"/></value>
            <typeClass>primitive</typeClass>
            <multiple>false</multiple>
            <typeName>title</typeName>
        </fields>
    </xsl:template>
    <xsl:template name="author">
        <fields>
            <value>
                <xsl:call-template name="author-name"/>
                <xsl:call-template name="author-affiliation"/>
            </value>
            <value></value>
            <typeClass>compound</typeClass>
            <multiple>true</multiple>
            <typeName>author</typeName>
        </fields>
    </xsl:template>
    <xsl:template name="author-name">
        <authorName>
            <value>@TODO-AUTHOR-NAME@</value>
            <typeClass>primitive</typeClass>
            <multiple>false</multiple>
            <typeName>authorName</typeName>
        </authorName>
    </xsl:template>
    <xsl:template name="author-affiliation">
        <authorAffiliation>
            <value>@TODO-AUTHOR-AFFILIATION@</value>
            <typeClass>primitive</typeClass>
            <multiple>false</multiple>
            <typeName>authorAffiliation</typeName>
        </authorAffiliation>
    </xsl:template>
    <xsl:template name="contact">
        <fields>
            <value>
                <xsl:call-template name="contact-email"/>
                <xsl:call-template name="contact-name"/>
            </value>
            <value></value>
            <typeClass>compound</typeClass>
            <multiple>true</multiple>
            <typeName>datasetContact</typeName>
        </fields>
    </xsl:template>
    <xsl:template name="contact-email">
        <datasetContactEmail>
            <typeClass>primitive</typeClass>
            <multiple>false</multiple>
            <typeName>datasetContactEmail</typeName>
            <value>TODO-CONTACT-EMAIL@dans.knaw.nl</value>
        </datasetContactEmail>
    </xsl:template>
    <xsl:template name="contact-name">
        <datasetContactName>
            <typeClass>primitive</typeClass>
            <multiple>false</multiple>
            <typeName>datasetContactName</typeName>
            <value>@TODO-CONTACT-NAME@</value>
        </datasetContactName>
    </xsl:template>
    <xsl:template name="description">
        <fields>
            <value>
                <dsDescriptionValue>
                    <value><xsl:value-of select="/ddi:DDIInstance/s:StudyUnit/s:Abstract/r:Content"/></value>
                    <multiple>false</multiple>
                    <typeClass>primitive</typeClass>
                    <typeName>dsDescriptionValue</typeName>
                </dsDescriptionValue>
            </value>
            <value/>
            <typeClass>compound</typeClass>
            <multiple>true</multiple>
            <typeName>dsDescription</typeName>
        </fields>
    </xsl:template>
    <xsl:template name="diciplines">
        <fields>
            <value>Medicine, Health and Life Sciences</value><value/>
            <typeClass>controlledVocabulary</typeClass>
            <multiple>true</multiple>
            <typeName>subject</typeName>
        </fields>
    </xsl:template>
</xsl:stylesheet>
