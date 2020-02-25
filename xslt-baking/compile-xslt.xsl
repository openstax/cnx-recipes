<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:phil="https://philschatz.com"
  expand-text="true"
  version="3.0">
  
  <xsl:output method="xml" indent="yes"/>

  <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

  <!-- A. Add Titles to notes -->
  <xsl:template match="/j:map/j:array[@key='Config_Notes']/j:map">
    <xsl:variable name="className" select="j:string[@key='className']/text()"/>
    <xsl:variable name="labelText" select="j:string[@key='labelText']/text()"/>
    
    <axsl:template match="h:*[@data-type='note'][@class][phil:hasClass(@class, '{$className}')]">
      <axsl:message>We found a "{$className}"! Adding labeltext to <axsl:value-of select="@id"/></axsl:message>
      <axsl:copy>
        <axsl:apply-templates select="@*"/>
        <h:h2>{$labelText}</h:h2>
        <axsl:apply-templates select="node()"/>
      </axsl:copy>
    </axsl:template>
  </xsl:template>


  <xsl:template match="/j:map/j:array[@key='Config_ChapterCompositePages']">
    <axsl:template match="*[@data-type='chapter']">
      <axsl:copy>
        <axsl:apply-templates select="@*|node()"/>

        <xsl:apply-templates select="node()" mode="INSIDE"/>
      </axsl:copy>
    </axsl:template>

    <xsl:apply-templates select="node()" mode="OUTSIDE_FOR_REMOVAL"/>
  </xsl:template>

  <xsl:template match="/j:map/j:array[@key='Config_ChapterCompositePages']/j:map" mode="INSIDE">
    <xsl:variable name="className" select="j:string[@key='className']/text()"/>
    <xsl:variable name="clusterBy" select="j:string[@key='clusterBy']/text()"/>
    <xsl:variable name="name" select="j:string[@key='name']/text()"/>
    
    <axsl:message>Building end-of-chapter section "{$className}"</axsl:message>
    <h:div data-type="composite-page" class="os-eoc os-{$className}-container" data-uuid-key="{$className}">
      <h:h2>{$name}</h:h2>
      <!-- from _createChapterComposite -->
      <axsl:apply-templates select=".//h:section[@class][phil:hasClass(@class, '{$className}')]" mode="shallow-move"/>
    </h:div>

  </xsl:template>

  <xsl:template match="/j:map/j:array[@key='Config_ChapterCompositePages']/j:map" mode="OUTSIDE_FOR_REMOVAL">
    <xsl:variable name="className" select="j:string[@key='className']/text()"/>
    <xsl:variable name="clusterBy" select="j:string[@key='clusterBy']/text()"/>
    <xsl:variable name="name" select="j:string[@key='name']/text()"/>

    <!-- Delete the node at the original location since we are moving it, and discard the moved title. -->
    <axsl:template match="*[@data-type='chapter']//h:section[@class][phil:hasClass(@class, '{$className}')]"/>
    <axsl:template match="*[@data-type='chapter']//h:section[@class][phil:hasClass(@class, '{$className}')]/*[@data-type='title']"/>
  </xsl:template>


  <!-- generate the root -->
  <xsl:template match="/">
    <axsl:transform
      extension-element-prefixes="phil"
      exclude-result-prefixes="xs fn j h phil"
      expand-text="true"
      version="3.0">

      <axsl:output method="xhtml" indent="yes" html-version="5.0"/>
      <xsl:apply-templates/>


      <!-- Identity transform. Anything that is not matched is copied over -->
      <axsl:template match="@*|node()">
        <axsl:copy>
          <axsl:apply-templates select="@*|node()"/>
        </axsl:copy>
      </axsl:template>

      <axsl:template match="@*|node()" mode="shallow-move">
        <axsl:copy>
          <axsl:apply-templates select="@*|node()"/>
        </axsl:copy>
      </axsl:template>

      <axsl:function name="phil:hasClass" as="xs:boolean">
        <axsl:param name="class" as="xs:string"/>
        <axsl:param name="className" as="xs:string"/>
        <axsl:sequence select="fn:exists(fn:index-of(fn:tokenize($class, '\s+'), $className))"/>
      </axsl:function>



    </axsl:transform>
  </xsl:template>

  <!-- Recurse -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

</xsl:transform>	
