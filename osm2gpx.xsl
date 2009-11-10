<?xml version="1.0" encoding="UTF-8"?>

<!--
osm2gpx.xsl converts a osm-file to an gpx-file
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY tab "&#9;">
<!ENTITY cr "&#13;">
<!ENTITY quot "&#34;">
<!ENTITY lt "&#60;">
<!ENTITY qt "&#62;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:strip-space elements="*"/>

<xsl:param name="osm_key">None</xsl:param><!-- "None" shouldn't be an OSM-Key otherwiese the output isn't as expectet -->
<xsl:param name="osm_value">None</xsl:param>
<xsl:param name="filter_key">None</xsl:param><!-- lists all nodes/areas with this tag -->
<xsl:param name="invert_filter1">no</xsl:param><!-- if != "no" the first filter is inverted -->
<xsl:param name="filter2_key">None</xsl:param>
<xsl:param name="invert_filter2">no</xsl:param>
<xsl:param name="dscr">None</xsl:param>

<xsl:template match="osm">
<xsl:text disable-output-escaping="yes"><![CDATA[<?xml version="1.0" encoding="UTF-8"?>
<gpx
version="1.1"
creator="osm to gpx script"> 
<metadata>
  <name> waypoints exractet from OSM</name>
  <desc> ]]></xsl:text>a list of nodes (<xsl:value-of select='$osm_key'/>=<xsl:value-of select='$osm_value'/>) <xsl:text disable-output-escaping="yes"><![CDATA[</desc>
  <author>
   <name> Karsten Hinz </name>
  </author>
  <copyright author="all">
   <year> 2009 </year>
   <license> http://creativecommons.org/licenses/by-sa/2.0/ </license>
  </copyright>
  <link href="http://www.openstreetmap.org">
    <text> OpenStreetMap </text>
    <type> text </type>
  </link>
 </metadata>]]></xsl:text>
<xsl:apply-templates select="node"/>
<xsl:apply-templates select="way"/>
<xsl:text disable-output-escaping="yes">
<![CDATA[</gpx>]]>
</xsl:text>
</xsl:template>


<xsl:template match="node">
<xsl:for-each select="tag">
<xsl:if test='@k=$osm_key and @v=$osm_value'>

<xsl:choose>
 <xsl:when test='((../tag[@k=$filter_key] and ../tag[@k=$filter_key]/@v) and $invert_filter1="no") or 
		(not($invert_filter1="no") and not(../tag[@k=$filter_key] and ../tag[@k=$filter_key]/@v))'>
 &lt;wpt lat=&quot;<xsl:value-of select='../@lat'/>&quot; lon=&quot;<xsl:value-of select='../@lon'/>&quot;&gt;
  &lt;time&gt;<xsl:value-of select='../@timestamp'/>&lt;/time>
  &lt;name&gt;<xsl:value-of select='substring($osm_value,0,4)'/><xsl:value-of select='substring($osm_value,string-length($osm_value),1)'/><xsl:number level="any" count='tag[@v=$osm_value]' />&lt;/name&gt;
  &lt;desc&gt;<xsl:value-of select='$dscr'/> - <xsl:value-of select='$osm_key'/>=<xsl:value-of select='$osm_value'/>&lt;/desc&gt;
  &lt;sym&gt;<xsl:value-of select='$osm_value'/>&lt;/sym&gt;
 &lt;/wpt>
 </xsl:when>
 <xsl:when test='((../tag[@k=$filter2_key] and ../tag[@k=$filter2_key]/@v) and $invert_filter1="no") or 
		(not($invert_filter2="no") and not(../tag[@k=$filter2_key] and ../tag[@k=$filter2_key]/@v))'>
 &lt;wpt lat=&quot;<xsl:value-of select='../@lat'/>&quot; lon=&quot;<xsl:value-of select='../@lon'/>&quot;&gt;
  &lt;time><xsl:value-of select='../@timestamp'/>&lt;/time>
  &lt;name&gt;<xsl:value-of select='substring($osm_value,0,4)'/><xsl:value-of select='substring($osm_value,string-length($osm_value),1)'/><xsl:number level="any" count='tag[@v=$osm_value]'/>&lt;/name&gt;
  &lt;desc&gt;<xsl:value-of select='$dscr'/> - <xsl:value-of select='$osm_key'/>=<xsl:value-of select='$osm_value'/>&lt;/desc&gt;
  &lt;sym&gt;<xsl:value-of select='$osm_value'/>&lt;/sym&gt;
 &lt;/wpt> 
</xsl:when>
</xsl:choose>

</xsl:if>
</xsl:for-each>
</xsl:template>


<xsl:template match="way">
<xsl:variable name="nodes" select="../node[@id=current()/nd/@ref]"/>
<xsl:for-each select="tag">
<xsl:if test='@k=$osm_key and @v=$osm_value'>

<xsl:choose>
 <xsl:when test='((../tag[@k=$filter_key] and ../tag[@k=$filter_key]/@v) and $invert_filter1="no") or 
		(not($invert_filter1="no") and not(../tag[@k=$filter_key] and ../tag[@k=$filter_key]/@v))'>
 &lt;wpt lat=&quot;<xsl:value-of select='sum($nodes/@lat) div count($nodes)'/>&quot; lon=&quot;<xsl:value-of select='sum($nodes/@lon) div count($nodes)'/>&quot;&gt;
  &lt;time&gt;<xsl:value-of select='../@timestamp'/>&lt;/time>
  &lt;name&gt;<xsl:value-of select='substring($osm_value,0,4)'/><xsl:value-of select='substring($osm_value,string-length($osm_value),1)'/><xsl:number level="any" count='tag[@v=$osm_value]' />&lt;/name&gt;
  &lt;desc&gt;<xsl:value-of select='$dscr'/> - <xsl:value-of select='$osm_key'/>=<xsl:value-of select='$osm_value'/>&lt;/desc&gt;
  &lt;sym&gt;<xsl:value-of select='$osm_value'/>&lt;/sym&gt;
 &lt;/wpt>
 </xsl:when>
 <xsl:when test='((../tag[@k=$filter2_key] and ../tag[@k=$filter2_key]/@v) and $invert_filter1="no") or 
		(not($invert_filter2="no") and not(../tag[@k=$filter2_key] and ../tag[@k=$filter2_key]/@v))'>
 &lt;wpt lat=&quot;<xsl:value-of select='sum($nodes/@lat) div count($nodes)'/>&quot; lon=&quot;<xsl:value-of select='sum($nodes/@lon) div count($nodes)'/>&quot;&gt;
  &lt;time><xsl:value-of select='../@timestamp'/>&lt;/time>
  &lt;name&gt;<xsl:value-of select='substring($osm_value,0,4)'/><xsl:value-of select='substring($osm_value,string-length($osm_value),1)'/><xsl:number level="any" count='tag[@v=$osm_value]'/>&lt;/name&gt;
  &lt;desc&gt;<xsl:value-of select='$dscr'/> - <xsl:value-of select='$osm_key'/>=<xsl:value-of select='$osm_value'/>&lt;/desc&gt;
  &lt;sym&gt;<xsl:value-of select='$osm_value'/>&lt;/sym&gt;
 &lt;/wpt> 
 </xsl:when>
</xsl:choose>

</xsl:if>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

