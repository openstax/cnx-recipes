<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
  version="1.0">

  <xsl:output omit-xml-declaration="yes"/>

  <xsl:variable name="PREFIX">/contents/</xsl:variable>

  <!-- identity -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Convert `<a href="/contents/{uuid}@{ver}#{id}">` to `<a href="/contents/{uuid}@{ver}.xhtml#{id}">` -->
  <xsl:template match="h:a/@href">
    <xsl:variable name="href" select="."/>
    <xsl:choose>
      <xsl:when test="substring($href, 1, string-length($PREFIX)) = $PREFIX">
        <xsl:variable name="afterContents">
          <xsl:value-of select="substring($href, string-length($PREFIX) + 1)"/>
        </xsl:variable>
        <xsl:variable name="hasHash" select="contains($href, '#')"/>
        <xsl:variable name="uuidAndVer">
          <xsl:choose>
            <xsl:when test="$hasHash">
              <xsl:value-of select="substring-before($afterContents, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$afterContents"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hashId">
          <xsl:value-of select="substring-after($afterContents, '#')"/>
        </xsl:variable>

        <xsl:variable name="result">
          <xsl:value-of select="$uuidAndVer"/>
          <xsl:text>.xhtml</xsl:text>
          <xsl:if test="$hasHash">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$hashId"/>
          </xsl:if>
        </xsl:variable>
        <!-- <xsl:message><xsl:value-of select="$href"/> : afterContents: <xsl:value-of select="$afterContents"/></xsl:message> -->
        <!-- <xsl:message><xsl:value-of select="$href"/> : hasHash: <xsl:value-of select="$hasHash"/></xsl:message> -->
        <!-- <xsl:message><xsl:value-of select="$href"/> : uuidAndVer: <xsl:value-of select="$uuidAndVer"/></xsl:message> -->
        <!-- <xsl:message><xsl:value-of select="$href"/> : hashId: <xsl:value-of select="$hashId"/></xsl:message> -->
        <!-- <xsl:message><xsl:value-of select="$href"/> : result: <xsl:value-of select="$result"/></xsl:message> -->

        <xsl:attribute name="href">
          <xsl:value-of select="$result"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:message><xsl:value-of select="$href"/> : NOTHING</xsl:message> -->
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
