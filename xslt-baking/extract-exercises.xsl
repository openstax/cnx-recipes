<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  expand-text="yes"
  version="3.0">
  
  <xsl:output method="text" indent="yes"/>

  <xsl:key name="identified-element" match="*[@id]" use="@id"/>

  <xsl:template match="/">
    <xsl:variable name="json">
      <j:array>
        <xsl:apply-templates select="node()"/>
      </j:array>
    </xsl:variable>
    <xsl:value-of select="xml-to-json($json, map{'indent':true()})"/>
  </xsl:template>

  <xsl:template match="*[@data-type='chapter']">
    <xsl:variable name="chapterNumber" select="h:h1[@data-type='document-title']/*[@class='os-number'][1]/text()" />
    <j:map>
      <j:number key="chapter"><xsl:value-of select="$chapterNumber"/></j:number>
      <j:array key="exercises">
        <xsl:apply-templates select="node()"/>
      </j:array>
    </j:map>
  </xsl:template>

  <xsl:template match="*[@data-type='composite-page']//*[@data-type='exercise']">
    <xsl:variable name="exerciseNumber" select="*[@data-type='problem']/*[@class='os-number']/text()"/>
    <xsl:variable name="answerHref" select="*[@data-type='problem']/h:a[@class='os-number']/@href"/>
    <xsl:variable name="problem" select="*[@data-type='problem']/*[@class='os-problem-container']"/>
    <xsl:variable name="options" select="$problem/h:ol[@type='a']"/>
    <xsl:variable name="stimulusRoot" select="if (count($options/*) > 1) then ($problem/*[1]) else ($problem)"/>

    <!-- <xsl:variable name="stimulus" select="$problem/*[1]"/> -->
    <xsl:variable name="stimulusText">
      <xsl:apply-templates mode="stringify" select="$stimulusRoot/node()"/>
    </xsl:variable>

    <xsl:variable name="stimulusImages" select="$stimulusRoot//h:img/@src"/>
    
    <j:map>
      <j:number key="number"><xsl:value-of select="$exerciseNumber"/></j:number>
      
      <xsl:call-template name="stringifyOrReportWhyNot">
        <xsl:with-param name="key">stimulus</xsl:with-param>
        <xsl:with-param name="context" select="$stimulusText"/>
      </xsl:call-template>

      <xsl:call-template name="constructImage">
        <xsl:with-param name="key">stimulus</xsl:with-param>
        <xsl:with-param name="hrefs" select="$stimulusImages"/>
      </xsl:call-template>

      <!-- Decide whether to convert the options or skip them -->
      <xsl:if test="$options">
        <j:array key="options">
          <xsl:for-each select="$options/h:li">
            <xsl:variable name="option">
              <xsl:apply-templates mode="stringify" select="node()"/>
            </xsl:variable>
            <xsl:variable name="optionImages" select=".//h:img/@src"/>

            <j:map>
              <xsl:call-template name="stringifyOrReportWhyNot">
                <xsl:with-param name="key">option</xsl:with-param>
                <xsl:with-param name="context" select="$option"/>
              </xsl:call-template>

              <xsl:call-template name="constructImage">
                <xsl:with-param name="key">option</xsl:with-param>
                <xsl:with-param name="hrefs" select="$optionImages"/>
              </xsl:call-template>

            </j:map>
          </xsl:for-each>
        </j:array>
      </xsl:if>

      <xsl:if test="$answerHref">
        <xsl:variable name="answerElement" select="key('identified-element', substring-after($answerHref, '#'))"/>
        <xsl:variable name="answer">
          <xsl:apply-templates mode="stringify" select="$answerElement/node()"/>
        </xsl:variable>

        <xsl:call-template name="stringifyOrReportWhyNot">
          <xsl:with-param name="key">answer</xsl:with-param>
          <xsl:with-param name="context" select="$answer"/>
        </xsl:call-template>
      </xsl:if>
    </j:map>
  </xsl:template>


  <xsl:template name="stringifyOrReportWhyNot">
    <xsl:param name="key"/>
    <xsl:param name="context"/>

    <j:string>
      <xsl:choose>
        <xsl:when test="$context[not(*)]">
          <xsl:attribute name="key">
            <xsl:value-of select="$key"/>
          </xsl:attribute>
          <xsl:value-of select="normalize-space($context)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="key">
            <xsl:text>unconverted_</xsl:text>
            <xsl:value-of select="$key"/>
          </xsl:attribute>
          <xsl:text>Unconverted element: </xsl:text>
          <xsl:value-of select="$context/*[1]/local-name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </j:string>
  </xsl:template>


  <xsl:template name="constructImage">
    <xsl:param name="key"/>
    <xsl:param name="hrefs"/>

    <xsl:if test="count($hrefs) > 1">
      <xsl:message>Multiple Images found. Only using the first one: <xsl:value-of select="$hrefs"/></xsl:message>
    </xsl:if>

    <xsl:if test="$hrefs">
      <xsl:variable name="href" select="$hrefs[1]"/>
      <j:string>
        <xsl:attribute name="key">
          <xsl:value-of select="$key"/>
          <xsl:text>_image</xsl:text>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="starts-with($href, 'http')">
            <xsl:value-of select="normalize-space($href)"/>
          </xsl:when>
          <xsl:when test="starts-with($href, 'm')">
            <xsl:variable name="module" select="substring-before($href, '/')"/>
            <xsl:variable name="filename" select="substring-after($href, '/')"/>
            <xsl:text>https://legacy.cnx.org/content/</xsl:text>
            <xsl:value-of select="$module"/>
            <xsl:text>/latest/</xsl:text>
            <xsl:value-of select="$filename"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>Unknown image ref: "<xsl:value-of select="$href"/>"</xsl:message>
            <xsl:text>[Unknown image ref: "</xsl:text>
            <xsl:value-of select="$href"/>
            <xsl:text>"]</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </j:string>
    </xsl:if>
  </xsl:template>


  <xsl:template mode="stringify" match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="stringify" match="h:em">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates mode="stringify" select="node()"/>
    <xsl:text>*</xsl:text>
  </xsl:template>

  <xsl:template mode="stringify" match="h:strong">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates mode="stringify" select="node()"/>
    <xsl:text>**</xsl:text>
  </xsl:template>

  <xsl:template mode="stringify" match="h:a[starts-with(@href, '#')]">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates mode="stringify" select="node()"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template mode="stringify" match="h:sub">
    <xsl:text>_</xsl:text>
    <xsl:apply-templates mode="stringify" select="node()"/>
  </xsl:template>

  <xsl:template mode="stringify" match="h:sup">
    <xsl:text>^</xsl:text>
    <xsl:apply-templates mode="stringify" select="node()"/>
  </xsl:template>

  <xsl:template mode="stringify" match="h:span|h:div|h:p|h:br">
    <xsl:apply-templates mode="stringify" select="node()"/>
  </xsl:template>

  <!-- Discard figures and images because we extracted their URL out already -->
  <xsl:template mode="stringify" match="h:figure|h:img"/>

  <!-- Discard titles -->
  <xsl:template mode="stringify" match="h:span[@data-type='title']"/>

  <!-- **************** 
       * Math 
       **************** -->
  <xsl:template mode="stringify" match="m:annotation-xml"/>

  <!-- Unwrap -->
  <xsl:template mode="stringify" match="
      m:math
    | m:semantics
    | m:mrow
    | m:mn
    | m:mi
    | m:mo
    | m:mtext
    | m:mspace
    | m:mstyle
    ">
    <xsl:apply-templates mode="stringify" select="node()"/>
  </xsl:template>

  <xsl:template mode="stringify" match="m:mfrac">
    <xsl:variable name="numer">
      <xsl:apply-templates mode="stringify" select="*[1]"/>
    </xsl:variable>
    <xsl:variable name="denom">
      <xsl:apply-templates mode="stringify" select="*[2]"/>
    </xsl:variable>

    <xsl:call-template name="parenthesize">
      <xsl:with-param name="value" select="$numer"/>
    </xsl:call-template>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="parenthesize">
      <xsl:with-param name="value" select="$denom"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="stringify" match="m:msup">
    <xsl:apply-templates mode="stringify" select="*[1]"/>
    <xsl:text>^</xsl:text>
    <xsl:apply-templates mode="stringify" select="*[2]"/>
  </xsl:template>

  <xsl:template mode="stringify" match="m:msub">
    <xsl:apply-templates mode="stringify" select="*[1]"/>
    <xsl:text>_</xsl:text>
    <xsl:apply-templates mode="stringify" select="*[2]"/>
  </xsl:template>

  <xsl:template mode="stringify" match="m:msubsup">
    <xsl:apply-templates mode="stringify" select="*[1]"/>
    <xsl:text>_</xsl:text>
    <xsl:apply-templates mode="stringify" select="*[2]"/>
    <xsl:text>^</xsl:text>
    <xsl:apply-templates mode="stringify" select="*[3]"/>
  </xsl:template>

  <xsl:template name="parenthesize">
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="$value/*">
        <xsl:copy-of select="$value"/>
      </xsl:when>
      <xsl:when test="string-length(normalize-space($value/text())) &lt; 3">
        <xsl:copy-of select="$value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(</xsl:text>
        <xsl:copy-of select="$value"/>
        <xsl:text>)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="node()">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

</xsl:transform>	
