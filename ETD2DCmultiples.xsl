<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
    <xsl:import href="MARC21slimUtils.xsl"/>
    <xsl:output name="xml" method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:output name="text" encoding="UTF-8" method="text"/>
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="marc:record">
        
        <xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>
        <xsl:variable name="associatedFile" select="marc:datafield[@tag=035]/marc:subfield[@code='a']"/>
        
<!-- Builds DC metadata file, and writes to directory named by PQDT file number -->
        <xsl:result-document href="{substring($associatedFile,9,7)}/dublin_core.xml" encoding="UTF-8" format="xml">
                <dublin_core>
                    <!-- author-->
                    <dcvalue element="contributor" qualifier="author"><xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!--title-->
                    <dcvalue element="title" qualifier="none"><xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!--date-->
                    <dcvalue element="date" qualifier="issued"><xsl:value-of select="marc:datafield[@tag=792]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!--publisher-->
                    <dcvalue element="publisher" qualifier="none"><xsl:value-of select="marc:datafield[@tag=710]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!-- extent -->
                    <dcvalue element="format" qualifier="extent"><xsl:value-of select="marc:datafield[@tag=300]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!-- abstract -->
                    <xsl:for-each select="marc:datafield[@tag=520]">
                        <dcvalue element="description" qualifier="abstract"><xsl:value-of select="marc:subfield[@code='a']" /></dcvalue>
                    </xsl:for-each>
                    
                    <!-- description -->
                    <dcvalue element="description" qualifier="none"><xsl:value-of select="marc:datafield[@tag=502]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!-- subject -->
                    <xsl:for-each select="marc:datafield[@tag=650]">
                        <dcvalue element="subject" qualifier="none"><xsl:value-of select="marc:subfield[@code='a']" /></dcvalue>
                    </xsl:for-each>
                    
                    <!-- isbn -->
                    <dcvalue element="identifier" qualifier="isbn"><xsl:value-of select="marc:datafield[@tag=020]/marc:subfield[@code='a']" /></dcvalue>
                    
                    <!-- type -->
                    <dcvalue element="type" qualifier="none"><xsl:text>Thesis or Dissertation</xsl:text></dcvalue>
                    
                    <!-- associated file - needs to be edited to remove "(UMI)AAI" prefix to associate file name -->
                    <dcvalue element="identifier" qualifier="other"><xsl:value-of select="substring($associatedFile,9,7)" /></dcvalue> 
                    <!-- associated file - this version for UNB inhouse scans 
                    <dcvalue element="identifier" qualifier="other"><xsl:value-of select="marc:datafield[@tag=871]/marc:subfield[@code='c']" /></dcvalue>-->
                    
                    <!-- language -->
                    <dcvalue element="language" qualifier="none"><xsl:value-of select="substring($controlField008,36,2)"/></dcvalue>
                    
                    <!-- citation builder -->
                    <dcvalue element="identifier" qualifier="citation">
                        <xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']" /> (<xsl:value-of select="marc:datafield[@tag=792]/marc:subfield[@code='a']" />). <xsl:value-of select="marc:datafield[@tag=245]/marc:subfield[@code='a']" /><xsl:text> </xsl:text> <xsl:value-of select="marc:datafield[@tag=710]/marc:subfield[@code='a']" />
                    </dcvalue>
                    
                </dublin_core>
            </xsl:result-document>
        
<!-- Builds contents text file for DSpace batch ingest process, and writes to same directory as above -->        
        <xsl:result-document href="{substring($associatedFile,9,7)}/contents" encoding="UTF-8" format="text">
            <xsl:value-of select="substring($associatedFile,9,7)"/><xsl:text>.pdf&#09;bundle:ORIGINAL</xsl:text>
            
        </xsl:result-document>
        
    </xsl:template>
    
</xsl:stylesheet>