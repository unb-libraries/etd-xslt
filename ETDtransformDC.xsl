<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
    <xsl:import href="MARC21slimUtils.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <metadata>
            <xsl:apply-templates/>
        </metadata>
    </xsl:template>
    
    <xsl:template match="marc:record">
        <xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>
        <xsl:variable name="associatedFile" select="marc:datafield[@tag=035]/marc:subfield[@code='a']"/>
        
        <dublin_core>
            <!-- author-->
            <dc.contributor.author><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']" /></dc.contributor.author>
            
            <!--title-->
            <dc.title><xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='a']" /></dc.title>
            
            <!--date-->
            <dc.date.issued><xsl:value-of select="marc:datafield[@tag=792]/marc:subfield[@code='a']" /></dc.date.issued>
            
            <!--publisher-->
            <dc.publisher><xsl:value-of select="marc:datafield[@tag=710]/marc:subfield[@code='a']" /></dc.publisher>
            
            <!-- extent -->
            <dc.format.extent><xsl:value-of select="marc:datafield[@tag=300]/marc:subfield[@code='a']" /></dc.format.extent>
                       
            <!-- abstract -->
            <xsl:for-each select="marc:datafield[@tag=520]">
                <dc.description.abstract><xsl:value-of select="marc:subfield[@code='a']" /></dc.description.abstract>
            </xsl:for-each>
            
            <!-- description -->
            <dc.description><xsl:value-of select="marc:datafield[@tag=502]/marc:subfield[@code='a']" /></dc.description>
            
            <!-- subject -->
            <xsl:for-each select="marc:datafield[@tag=650]">
                <dc.subject><xsl:value-of select="marc:subfield[@code='a']" /></dc.subject>
            </xsl:for-each>
            
            <!-- isbn (not required for UNB inhouse scans) -->
            <dc.identifier.isbn><xsl:value-of select="marc:datafield[@tag=020]/marc:subfield[@code='a']" /></dc.identifier.isbn> 
            
            <!-- type -->
            <dc.type><xsl:text>Thesis or Dissertation</xsl:text></dc.type>
            
            <!-- associated file - needs to be edited to remove "(UMI)AAI" prefix to associate file name-->
            <dc.identifier.other><xsl:value-of select="substring($associatedFile,9,7)" /></dc.identifier.other> 
            <!-- associated file - this version for UNB inhouse scans 
            <dc.identifier.other><xsl:value-of select="marc:datafield[@tag=871]/marc:subfield[@code='c']" /></dc.identifier.other>-->
            
            <!-- language -->
            <dc.language><xsl:value-of select="substring($controlField008,36,2)"/></dc.language>
            
            <!-- citation builder -->
            <dc.identifier.citation>
                <xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']" /> (<xsl:value-of select="marc:datafield[@tag=792]/marc:subfield[@code='a']" />). <xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='a']" /><xsl:text> </xsl:text> <xsl:value-of select="marc:datafield[@tag=710]/marc:subfield[@code='a']" />
            </dc.identifier.citation>

        </dublin_core>
                     
    </xsl:template>

</xsl:stylesheet>