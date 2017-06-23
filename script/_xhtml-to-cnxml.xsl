<xsl:stylesheet version="1.0"
  xmlns="http://cnx.rice.edu/cnxml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >

  <xsl:template name="discard"/>

  <!-- Copy all the HTML elements in the original file -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:message>ERROR: Did not convert <xsl:value-of select="local-name()"/>[@data-type="<xsl:value-of select="@data-type"/>"]</xsl:message>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Discard these attributes -->
  <xsl:template match="
    section/h3[@data-type='title']/@data-type
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
    | *[@data-type='chapter']
    | *[@data-type='page']
    | *[@data-type='document-title']
    ">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <!-- Convert these elements that have a data-type attribute to an element -->
  <xsl:template match="*[@data-type]">
    <xsl:element name="{@data-type}">
      <xsl:apply-templates select="@*[local-name() != 'data-type']|node()"/>
    </xsl:element>
  </xsl:template>

  <!-- Convert these elements that have the same element name in CNXML and HTML -->
  <xsl:template match="
      section
    | sup
    ">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>


  <!-- Custom conversions -->

  <xsl:template match="p">
    <para>
      <xsl:apply-templates select="@*|node()"/>
    </para>
  </xsl:template>

  <xsl:template match="ol">
    <list list-type="enumerated">
      <xsl:apply-templates select="@*|node()"/>
    </list>
  </xsl:template>

  <xsl:template match="ul">
    <list>
      <xsl:apply-templates select="@*|node()"/>
    </list>
  </xsl:template>

  <xsl:template match="li">
    <item>
      <xsl:apply-templates select="@*|node()"/>
    </item>
  </xsl:template>

  <xsl:template match="em">
    <emphasis effect="italics">
      <xsl:apply-templates select="@*|node()"/>
    </emphasis>
  </xsl:template>


  <xsl:template match="table">
    <table>
      <xsl:apply-templates select="@*"/>
      <tgroup>
        <tbody>
          <xsl:apply-templates select="tr"/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>

  <xsl:template match="tr">
    <row>
      <xsl:apply-templates select="@*|node()"/>
    </row>
  </xsl:template>

  <xsl:template match="td">
    <entry>
      <xsl:apply-templates select="@*|node()"/>
    </entry>
  </xsl:template>


</xsl:stylesheet>
