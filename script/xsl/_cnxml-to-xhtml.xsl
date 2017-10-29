<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:c="http://cnx.rice.edu/cnxml"
  exclude-result-prefixes="h mml c"
  >

  <xsl:import href="../../vendor/rhaptos.cnxmlutils/rhaptos/cnxmlutils/xsl/cnxml-to-html5.xsl"/>

  <!-- Wrap the root element inside a <body> tag -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="h:html">
        <!-- if it already has a root element then just copy it. This is needed for snippets that have multiple chapters -->
        <xsl:apply-templates select="node()"/>
      </xsl:when>
      <xsl:otherwise>
        <html>
          <body>
            <!-- In order to be technically well-formed these elements would need to be added as well
            <div data-type="metadata">
              <h1 data-type="document-title" itemprop="name">Book Title</h1>
              <a data-type="license" href="http://creativecommons.org/licenses/by/4.0/"> </a>
            </div>
            <nav id="toc">
              <ol>
              </ol>
            </nav>
            -->
            <xsl:apply-templates select="node()"/>
          </body>
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    <div data-type="document-title">$title</div>
    <div data-type="metadata">
      <div data-type="description">[METADATA_DESCRIPTION]</div>
      <div data-type="cnx-archive-shortid">[SHORTID_123]</div>
    </div>
  -->
  <xsl:template name="page-metadata">
    <xsl:param name="title"/>
    <xsl:value-of select="'&lt;div data-type=&quot;document-title&quot;>'" disable-output-escaping="yes" />
    <xsl:value-of select="$title"/>
    <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
    <xsl:value-of select="'&lt;div data-type=&quot;metadata&quot;>'" disable-output-escaping="yes" />
    <xsl:value-of select="'&lt;div data-type=&quot;description&quot;>'" disable-output-escaping="yes" />
    <xsl:value-of select="'[METADATA_DESCRIPTION]'" disable-output-escaping="yes" />
    <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
    <xsl:value-of select="'&lt;span data-type=&quot;cnx-archive-shortid&quot; data-value=&quot;SHORTID_123@9.9&quot;/>'" disable-output-escaping="yes" />
    <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
  </xsl:template>

  <!-- Convert specially-marked comments into elements -->
  <xsl:template match="comment()">
    <xsl:variable name="commentText" select="normalize-space(.)"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <xsl:choose>
      <xsl:when test="$commentText = 'START:Page'">
        <!--
          <div data-type="page">
            <div data-type="metadata">
              <div data-type="description">
        -->
        <xsl:value-of select="'&lt;div data-type=&quot;page&quot;>'" disable-output-escaping="yes" />
        <xsl:call-template name="page-metadata">
          <xsl:with-param name="title">[PAGE_TITLE]</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$commentText = 'END:Page'">
        <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'START:Preface'">
        <!--
          <div data-type="page" class="preface">
            <div data-type="metadata">
              <div data-type="description">
        -->
        <xsl:value-of select="'&lt;div data-type=&quot;page&quot; class=&quot;preface&quot;>'" disable-output-escaping="yes" />
        <xsl:call-template name="page-metadata">
          <xsl:with-param name="title">[PREFACE_TITLE]</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$commentText = 'END:Preface'">
        <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'START:Chapter'">
        <!-- <div data-type="chapter"> -->
        <xsl:value-of select="'&lt;div data-type=&quot;chapter&quot;>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'END:Chapter'">
        <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'START:Appendix'">
        <!-- <div data-type="chapter" class="appendix"> -->
        <xsl:value-of select="'&lt;div data-type=&quot;chapter&quot; class=&quot;appendix&quot;>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'END:Appendix'">
        <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'START:Unit'">
        <!-- <div data-type="chapter" class="appendix"> -->
        <xsl:value-of select="'&lt;div data-type=&quot;unit&quot;>'" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="$commentText = 'END:Unit'">
        <xsl:value-of select="'&lt;/div>'" disable-output-escaping="yes" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Unwrap the specially-marked root element -->
  <xsl:template match="c:hack-root" priority="1">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <!-- Copy all the HTML elements in the original file -->
  <xsl:template match="
      *[not(self::c:*) and not(self::mml:*)]/@*
    | node()[not(self::c:*) and not(self::mml:*) and not(parent::c:*) and not(parent::mml:*) and not(self::comment()) and not(self::c:hack-root)]
    ">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Ensure that the elements are in the XHTML namespace -->
  <xsl:template match="
      *[not(self::c:*) and not(self::mml:*) and not(self::c:hack-root)]
    ">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()"/>
      <!-- Ensure footnotes and glossary are created -->
      <xsl:if test="@data-type='page'">
        <xsl:call-template name="doc-level-template"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- If the root element is CNXML then wrap it in a Page. Shortcut. -->
  <xsl:template match="/c:*">
    <div data-type="chapter">
      <h1 data-type="document-title">Chapter Title</h1>
      <div data-type="page">
        <div data-type="document-title">Page Title</div>
        <xsl:apply-imports/>
        <xsl:call-template name="doc-level-template"/>
      </div>
    </div>
  </xsl:template>

  <!-- Convert all CNXML to HTML using the imported file -->
  <xsl:template match="c:*">
    <xsl:apply-imports/>
  </xsl:template>

  <!-- TODO: Inject Page metadata if there is none. So that validation passes -->

</xsl:stylesheet>
