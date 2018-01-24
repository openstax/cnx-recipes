<xsl:stylesheet version="1.0"
  xmlns="http://cnx.rice.edu/cnxml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >

  <xsl:output omit-xml-declaration="yes"/>

  <xsl:template name="discard"/>

  <!-- @data-label is a little annoying because we need to create a <label> element
      So we pass **EVERYTHING** through here so we can convert the attributes (except data-label)
      then data-label, then child nodes.
  -->
  <xsl:template name="children">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates mode="labelize" select="@data-label"/>
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="@data-label"/>
  <xsl:template mode="labelize" match="@data-label">
    <xsl:element name="label">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- Copy all the HTML elements in the original file -->
  <xsl:template name="ident" match="@*|node()">
    <xsl:copy>
      <xsl:call-template name="children"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="did-not-convert" match="*">
    <xsl:variable name="attribs">
      <xsl:if test="@data-type">[@data-type="<xsl:value-of select="@data-type"/>"]</xsl:if>
      <xsl:if test="@class">[@class="<xsl:value-of select="@class"/>"]</xsl:if>
      <xsl:if test="@id">[@id="<xsl:value-of select="@id"/>"]</xsl:if>
    </xsl:variable>
    <xsl:message>WARNING: Did not convert <xsl:value-of select="local-name()"/><xsl:value-of select="$attribs"/></xsl:message>
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="children"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="did-not-convert-attribute">
    <xsl:message>WARNING: Did not convert @<xsl:value-of select="local-name()"/>="<xsl:value-of select="."/>"</xsl:message>
    <xsl:copy>
      <xsl:call-template name="children"/>
    </xsl:copy>
  </xsl:template>

  <!-- Discard these attributes -->
  <xsl:template match="
      @data-type
    | *[@class = @data-type]/@class
    | @data-depth
    ">
    <xsl:call-template name="discard"/>
  </xsl:template>

  <!-- Convert these attributes by removing the "data-" prefix -->
  <xsl:template match="@data-type[. = 'foo']">
    <xsl:variable name="name" select="substring-after(@name, 'data-')"/>
    <xsl:attribute name="{$name}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- Retain these elements (structural) -->
  <xsl:template match="
      /div
    | /body
    | mml:*
    | *[@data-type='chapter']
    | *[@data-type='page']
    | *[@data-type='document-title']
    | *[@data-type='composite-page']

    " priority="9">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="children"/>
    </xsl:element>
  </xsl:template>

  <!-- Retain these attributes (structural) -->
  <!-- TODO: The @data-type="os-..." is here because the Chapter Outline snippet isn't actually in the Raw HTML but it is in a snippet for some reason, not sure why -->
  <xsl:template match="
      mml:*/@*
    | *[@data-type='chapter']/@data-type
    | *[@data-type='page']/@data-type
    | *[@data-type='document-title']/@data-type
    | *[@data-type='composite-page']/@data-type

    | *[@data-type='footnote-number']/@data-type
    | *[@data-type='footnote-link']/@data-type
    | *[@data-type='footnote-refs']/@data-type
    | *[@data-type='footnote-ref']/@data-type
    | *[@data-type='footnote-ref-link']/@data-type
    | *[@data-type='footnote-ref-content']/@data-type

    " priority="9">
    <xsl:copy>
      <xsl:call-template name="children"/>
    </xsl:copy>
  </xsl:template>

  <!-- Retain these elements but add a warning -->
  <xsl:template match="
      *[@data-type='footnote-number']
    | *[@data-type='footnote-link']
    | *[@data-type='footnote-refs']
    | *[@data-type='footnote-ref']
    | *[@data-type='footnote-ref-link']
    | *[@data-type='footnote-ref-content']

    | *[@data-type='glossary']
    | *[@data-type='glossary']/@data-type
    | *[@data-type='glossary-title']
    | *[@data-type='glossary-title']/@data-type

    | *[starts-with(@data-type, 'os-')]/@data-type
    " priority="9">
    <xsl:call-template name="did-not-convert"/>
  </xsl:template>

  <!-- Retain these attributes but add a warning -->
  <xsl:template match="
      *[starts-with(@data-type, 'os-')]/@data-type
    | *[@data-type='glossary']/@data-type
    | *[@data-type='glossary-title']/@data-type

    " priority="9">
    <xsl:call-template name="did-not-convert-attribute"/>
  </xsl:template>

  <!-- Convert these elements that have a data-type attribute to an element -->
  <xsl:template match="*[@data-type]">
    <xsl:element name="{@data-type}">
      <xsl:call-template name="children"/>
    </xsl:element>
  </xsl:template>

  <!-- Generate a BUG when data-type begins with "os-" -->
  <xsl:template match="*[starts-with(@data-type, 'os-')]">
    <xsl:message>WARNING: Found an element with data-type="<xsl:value-of select="@data-type"/>"</xsl:message>
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!-- Convert these elements that have the same element name in CNXML and HTML -->
  <xsl:template match="
      section
    | sup
    | figure
    ">
    <xsl:element name="{local-name()}">
      <xsl:call-template name="children"/>
    </xsl:element>
  </xsl:template>


  <!-- Custom conversions -->

  <xsl:template match="p">
    <para>
      <xsl:call-template name="children"/>
    </para>
  </xsl:template>

  <xsl:template match="ol">
    <list list-type="enumerated">
      <xsl:call-template name="children"/>
    </list>
  </xsl:template>

  <xsl:template match="ul">
    <list>
      <xsl:call-template name="children"/>
    </list>
  </xsl:template>

  <xsl:template match="li">
    <item>
      <xsl:call-template name="children"/>
    </item>
  </xsl:template>

  <xsl:template match="em">
    <emphasis effect="italics">
      <xsl:call-template name="children"/>
    </emphasis>
  </xsl:template>


  <xsl:template match="table">
    <table>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="caption"/>
      <tgroup>
        <tbody>
          <xsl:apply-templates select="tr|tbody/tr"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>

  <xsl:template match="caption">
    <caption>
      <xsl:call-template name="children"/>
    </caption>
  </xsl:template>

  <xsl:template match="tr">
    <row>
      <xsl:call-template name="children"/>
    </row>
  </xsl:template>

  <xsl:template match="td">
    <entry>
      <xsl:call-template name="children"/>
    </entry>
  </xsl:template>

  <xsl:template match="a">
    <link>
      <xsl:call-template name="children"/>
    </link>
  </xsl:template>

  <xsl:template match="a/@href">
    <xsl:attribute name="url">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="figcaption">
    <caption>
      <xsl:call-template name="children"/>
    </caption>
  </xsl:template>

  <xsl:template match="img">
    <image>
      <xsl:call-template name="children"/>
    </image>
  </xsl:template>


</xsl:stylesheet>
