<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
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
    <xsl:strip-space elements="*" />
    <xsl:output method="text"/>
    <xsl:variable name="delimiter" select="','"/>
    <xsl:key name="field" match="/ddi:DDIInstance/dataDscr/var/*" use="@*/string()"/>
    <!-- variable containing the first occurrence of each field -->
    <xsl:variable name="allFields"
        select="/ddi:DDIInstance/dataDscr/var/*[generate-id()=generate-id(key('field', @*/string()))]" />
    
    <xsl:template match="/">
        <xsl:for-each select="/ddi:DDIInstance/dataDscr/var">
            <xsl:for-each select="$allFields">
                <xsl:if test="local-name()='sumStat'">
                    <xsl:value-of select="@*/string()" />
                    <xsl:if test="following-sibling::sumStat">
                        <xsl:value-of select="$delimiter" />
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
            <xsl:call-template name="variablesvalue"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="variablesvalue">
        
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