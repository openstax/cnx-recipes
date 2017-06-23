<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:c="http://cnx.rice.edu/cnxml"
  >

  <xsl:import href="../rhaptos.cnxmlutils/rhaptos/cnxmlutils/xsl/cnxml-to-html5.xsl"/>

  <!-- Copy all the HTML elements in the original file -->
  <xsl:template match="
      *[not(self::c:*)]
    | *[not(self::c:*)]/@*
    | node()[not(self::c:*)]
    ">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- If the root element is CNXML then wrap it in a Page. Shortcut. -->
  <xsl:template match="/c:*">
    <div data-type="chapter">
      <h1 data-type="document-title">Chapter Title</h1>
      <div data-type="page">
        <div data-type="document-title">Page Title</div>
        <xsl:apply-imports/>
      </div>
    </div>
  </xsl:template>

  <!-- Convert all CNXML to HTML using the imported file -->
  <xsl:template match="c:*">
    <xsl:apply-imports/>
  </xsl:template>

  <!-- TODO: Inject Page metadata if there is none. So that validation passes -->

</xsl:stylesheet>
