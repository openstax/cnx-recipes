<xsl:transform 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://www.w3.org/1999/xhtml"
    version="1.0">

<xsl:template match="//*[@data-type='chapter'][position() != 12]">
    <!-- Remove chapters that are not 12 -->
</xsl:template>
<!-- <xsl:template match="//h:nav/h:ol/h:li[h:ol][position() != 12]"/> -->


<!-- (Default) This just copies everything else that was in the original document -->
<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:transform>