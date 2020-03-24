<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  expand-text="yes"
  version="3.0">

  <xsl:output method="text" indent="yes"/>

  <xsl:template match="/">{xml-to-json(., map{'indent':true()})}</xsl:template>

</xsl:transform>