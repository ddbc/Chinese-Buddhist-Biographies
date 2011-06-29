<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

<xsl:template match="/">
    <html>
        <head><title><xsl:value-of select="div/@key"/></title>
         
        <style type="text/css">
            body { font-size:14pt; 
            background-color:#F8FAFA;
            font-family: sans-serif;
            }
            #middle {float: left; width:60%;}
            
            #right {float: right; width:30%; margin-top:15%;border-left: black solid 3px; padding-left: 3%;}
            span.iba\:ddbc\:authPerson {color: red}
            span.iba\:ddbc\:authPlace {color: #939}
            span.iba\:ddbc\:authDate {color: #036}
        </style>
            <script type="text/javascript" src="http://authority.ddbc.edu.tw/webwidget/popup.js"></script>
           
        </head>
        <body>
            <script type="text/javascript" src="./wz_tooltip/wz_tooltip.js"/>
            <a href="javascript:void(0);" onmouseover="Tip('This is a tooltip')">simpleExample</a>
            <div id="middle"><xsl:apply-templates/></div>
            <div id="right"><xsl:apply-templates select="//note" mode="right"/></div>
            
        </body>
    </html>
</xsl:template>
    
    <xsl:template match="div/p">
        <p>
            <xsl:apply-templates/>
        </p>
        <hr/>
    </xsl:template>

    <!-- Person names  (have to wrap each text() in spans to leave <lb>s etc free)-->
    <xsl:template match="persName/text()">
    <span class="iba:ddbc:authPerson" title="{../@key}">
        <xsl:value-of select="."/></span>
</xsl:template>
        <xsl:template match="ref[@type='person']/text()">
        <span class="iba:ddbc:authPerson" title="{../substring-after(@target, '#')}">
            <xsl:value-of select="."/></span>
    </xsl:template>
        
    <!-- Place names  (have to wrap each text() in spans to leave <lb>s etc free) -->
    <xsl:template match="placeName/text()">        
                <span class="iba:ddbc:authPlace" title="{../@key}"><xsl:value-of select="."/></span>                  
    </xsl:template>
        <xsl:template match="ref[@type='place']/text()">
        <span class="iba:ddbc:authPlace" title="{../substring-after(@target, '#')}">
            <xsl:value-of select="."/></span>
    </xsl:template>
    
    <!-- Dates (have to wrap each text() in spans to leave <lb>s etc free) -->
    <xsl:template match="date/text()">
        <span class="iba:ddbc:authDate" title="{../@key}"><xsl:value-of select="."/></span>
    </xsl:template>
    <xsl:template match="ref[@type='date']/text()">
        <span class="iba:ddbc:authDate" title="{../substring-after(@target, '#')}"><xsl:value-of select="."/></span>
    </xsl:template>
    
    <!-- Notes -->
    <xsl:template match="note">
        <a href="#{count(preceding::note)+1}" id="fn{count(preceding::note)+1}"> [<xsl:value-of select="count(preceding::note)+1"/>]</a>
    </xsl:template>
    <xsl:template match="note" mode="right">
        <p id="{count(preceding::note)+1}"> <a href="#fn{count(preceding::note)+1}">[<xsl:value-of select="count(preceding::note)+1"/>]</a>: <xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="note/ref[not(@type)]">
        <xsl:variable name="cbetaRef">
            <!--    CBETA, T50, no. 2056, p. 292, c06    into  T50n2059_p0322c24  -->
            <xsl:value-of select="replace(current(),  '(CBETA, )(T\d{2})(, no. )(\d{4})(, p. )(\d{3})(, )(a|b|c)(\d{2})', '$2n$4_p0$6$8$9' )"/>
        </xsl:variable>
        <a href="http://w3.cbeta.org/cgi-bin/goto.pl?linehead={$cbetaRef}">
            <xsl:value-of select="."/></a>
    </xsl:template>

<xsl:template match="lb">
    <br/><xsl:value-of select="@n"/>:
</xsl:template>
    
    <xsl:template match="linkGrp">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <!-- Variant turns beginning anchor into [var] with pop up -->
    <xsl:template match="anchor[contains(@xml:id, 'beg')]">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="taisho">
            <xsl:value-of select="//app[@from = $id]/lem/text()"/>  
        </xsl:variable>
        <xsl:variable name="qisha">
            <xsl:value-of select="//app[@from = $id]/rdg[@wit='【磧】']"/>  
        </xsl:variable>
        <xsl:variable name="taichar" as="xs:double"> <!-- number of characters in the taisho that are  -->
            <xsl:value-of select="count(string-to-codepoints($taisho))"/>
        </xsl:variable>
        
        <xsl:element name="a">
            <xsl:attribute name="style">color:blue; text-decoration:none;</xsl:attribute>
            <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
            <xsl:attribute name="onmouseover">
                Tip('Taishō has: <xsl:value-of select="$taisho"/><xsl:text>&lt;br/></xsl:text>Qisha has:<xsl:value-of select="$qisha"/> ', WIDTH,200, PADDING,4,OPACITY,92)
            </xsl:attribute>
            [var]            
        </xsl:element>
         
    </xsl:template>
    
  <!-- Replaces the text() in front of a beginning anchor with the annotation  -->
    <!--  <xsl:template match="text()[preceding::*[1][name() = 'anchor'][contains(@xml:id, 'beg')]]">
        <xsl:variable name="id" select="preceding::anchor[1]/@xml:id"/>
        <xsl:variable name="taisho">
            <xsl:value-of select="//app[@from = $id]/lem/text()"/>  
        </xsl:variable>
        <xsl:variable name="qisha">
            <xsl:value-of select="//app[@from = $id]/rdg[@wit='【磧】']"/>  
        </xsl:variable>
        <xsl:variable name="taichar" as="xs:integer">
            <xsl:value-of select="count(string-to-codepoints($taisho))"/>
        </xsl:variable>
        taisho= "<xsl:value-of select="$taisho"/>"
        qisha="<xsl:value-of select="$qisha"/>"
        taichar="<xsl:value-of select="$taichar"/>"
      
         Replaced?:"<xsl:value-of select="replace(., '^\w+' , $qisha)"/>"         
         </xsl:template>   -->
    

</xsl:stylesheet>
