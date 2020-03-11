<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:phil="https://philschatz.com"
  extension-element-prefixes="phil"
  exclude-result-prefixes="xs fn j h phil"
  expand-text="true"
  version="3.0">
  
  <xsl:output method="xhtml" indent="yes" html-version="5.0"/>

  <xsl:template match="json-root">
    <xsl:apply-templates select="json-to-xml(.)"/>
  </xsl:template>

  <!-- A. Add a title to a note -->
  <xsl:template match="h:*[@class][phil:hasClass(@class, 'link-to-learning')]">
    <xsl:message>Woot! We found a link-to-learning! <xsl:value-of select="@id"/></xsl:message>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:h2>Link to Learning</h:h2>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- B. Number Figures in a Chapter -->
  <xsl:template match="*[@data-type='chapter']//h:figure">
    <xsl:variable name="thomas">
      <xsl:number count="*[@data-type='chapter']"/>
    </xsl:variable>
    <xsl:message>Found figure <xsl:number count="*[@data-type='chapter']"/>.<xsl:number count="h:figure" from="*[@data-type='chapter']" level="any"/></xsl:message>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:h2>Figure <xsl:value-of select="$thomas - 1"/>.<xsl:number count="h:figure" from="*[@data-type='chapter']" level="any"/></h:h2>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- C. Inject a Page at the end of a chapter -->
  <!-- $Config_ChapterCompositePages -->
  <xsl:template match="*[@data-type='chapter']">
    <xsl:variable name="className">summary</xsl:variable>
    <xsl:variable name="clusterBy">CLUSTER_SECTION</xsl:variable>
    <xsl:variable name="name">Summary</xsl:variable>

    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <h:div data-type="composite-page" class="os-eoc os-{$className}-container" data-uuid-key="{$className}">
        <h:h2>{$name}</h:h2>
        <!-- from _createChapterComposite -->
        <xsl:apply-templates select=".//h:section[@class][phil:hasClass(@class, $className)]" mode="shallow-move"/>
      </h:div>
    </xsl:copy>
  </xsl:template>
  <!-- Delete the node at the original location since we are moving it, and discard the moved title. -->
  <xsl:template match="*[@data-type='chapter']//h:section[@class][phil:hasClass(@class, 'summary')]"/>
  <xsl:template match="*[@data-type='chapter']//h:section[@class][phil:hasClass(@class, 'summary')]/*[@data-type='title']"/>


  <!-- Identity transform. Anything that is not matched is copied over -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="shallow-move">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:function name="phil:hasClass" as="xs:boolean">
    <xsl:param name="class" as="xs:string"/>
    <xsl:param name="className" as="xs:string"/>
    <xsl:sequence select="fn:exists(fn:index-of(fn:tokenize($class, '\s+'), $className))"/>
  </xsl:function>

</xsl:transform>	
