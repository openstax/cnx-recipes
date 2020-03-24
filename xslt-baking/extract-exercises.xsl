<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:phil="https://philschatz.com"
  version="1.0">
  
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <j:map>
      <xsl:apply-templates select="node()"/>
    </j:map>
  </xsl:template>

  <xsl:template match="*[@data-type='chapter']">
    <xsl:variable name="chapterNumber" select="h:h1[@data-type='document-title']/*[@class='os-number'][1]/text()" />
    <j:array>
      <xsl:attribute name="key">
        <xsl:value-of select="$chapterNumber"/>
      </xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </j:array>
  </xsl:template>

  <xsl:template match="*[@data-type='composite-page']//*[@data-type='exercise']">
    <xsl:variable name="exerciseNumber" select="*[@data-type='problem']/*[@class='os-number']/text()"/>
    <xsl:variable name="problem" select="*[@data-type='problem']/*[@class='os-problem-container']"/>
    <xsl:variable name="stimulus" select="$problem/h:div[1]"/>
    <xsl:variable name="options" select="$problem/h:ol[@type='a']"/>
    <j:map>
      <j:number key="number"><xsl:value-of select="$exerciseNumber"/></j:number>
      
      <!-- Decide whether to convert the stimulus or skip it -->
      <xsl:choose>
        <xsl:when test="$stimulus[not(*)]">
          <j:string key="stimulus"><xsl:value-of select="$stimulus/text()"/></j:string>
        </xsl:when>
        <xsl:otherwise>
          <j:string key="unconverted_stimulus">
            <!-- <xsl:copy-of select="$stimulus"/> -->
          </j:string>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Decide whether to convert the options or skip them -->
      <xsl:if test="$options">
        <j:array key="options">
          <xsl:for-each select="$options/h:li">
            <j:map>
              <xsl:choose>
                <xsl:when test="$options/h:li[not(*)]">
                  <j:string key="option"><xsl:value-of select="text()"/></j:string>
                </xsl:when>
                <xsl:otherwise>
                  <j:string key="unconverted_option"/>
                </xsl:otherwise>
              </xsl:choose>
            </j:map>
          </xsl:for-each>
        </j:array>
      </xsl:if>
    </j:map>
  </xsl:template>


  <xsl:template match="node()">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

</xsl:transform>	
