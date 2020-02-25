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

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="json-root">
    <xsl:apply-templates select="json-to-xml(.)"/>
  </xsl:template>

  <!-- Identity transform. Anything that is not matched is copied over -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:transform>