<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  version="1.0">

<!-- Number a Figure (just like the replacer example) -->
<xsl:template match="h:p">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <span class="baked-os-number">
      _BAKED_:<xsl:call-template name="figureNumberContent"/>
    </span>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>


<!-- Identity Transform -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


<!-- Utilities (these would be in different files) -->
<xsl:template name="figureNumberContent">
  <xsl:call-template name="chapterNumber"/>
  <xsl:text>.</xsl:text>
  <xsl:call-template name="figureNumber"/>
</xsl:template>


<xsl:template name="chapterNumber">
  <xsl:number count="*[@data-type='chapter']"/>
</xsl:template>

<xsl:template name="figureNumber">
  <xsl:number level="any" from="*[@data-type='chapter']" count="h:p"/>
</xsl:template>

<!-- Notes
  Can XSLT be multithreaded? Saxon's author answered with a link to the paper: https://stackoverflow.com/a/43584448
  Saxon Parallel talk: https://www.youtube.com/watch?v=WfkOxv6H6VY and more https://www.youtube.com/user/XMLPrague/search?query=parallel
  
-->

</xsl:stylesheet>
