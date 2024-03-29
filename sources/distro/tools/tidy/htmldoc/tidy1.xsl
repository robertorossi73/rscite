<?xml version="1.0"?>
<!--
    For generating the `tidy.1` man page from the
    output of `tidy -xml-help` and `tidy -xml-config`

    (c) 2005 (W3C) MIT, ERCIM, Keio University
    See tidy.h for the copyright notice.

    Written by Jelks Cabaniss and Arnaud Desitter

  CVS Info :

    $Author: arnaud02 $
    $Date: 2005/05/02 16:12:52 $
    $Revision: 1.2 $

-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:strip-space elements="description" />

<xsl:output method="text" />

<!--
    The default template match is to the document passed on the
    command line to the XSLT processor, currently "xml-help.xml".
    For the detailed config options section however, the template
    match is to the file "tidy-config.xml".  This is captured in
    the $CONFIG variable, declared here:
-->

<xsl:variable name="CONFIG" select="document('tidy-config.xml')"/>


<!-- Main Template: -->

<xsl:template match="/">
   <xsl:call-template name="header-section" />
   <xsl:call-template name="cmdline-section" />
   <xsl:call-template name="config-section" />
   <xsl:call-template name="manpage-see-also-section" />
</xsl:template>


<!-- Named Templates: -->


<xsl:template name="header-section">
  <xsl:text/>.\" tidy man page for the Tidy Sourceforge project
.TH tidy 1 "$Date: 2005/05/02 16:12:52 $" "HTML Tidy <xsl:value-of select="cmdline/@version" />" "User commands"
</xsl:template>


<xsl:template name="cmdline-section">
.SH NAME
\fBtidy\fR - validate, correct, and pretty-print HTML files
.br
(version: <xsl:value-of select="cmdline/@version" />)
.SH SYNOPSIS
\fBtidy\fR [option ...] [file ...] [option ...] [file ...]
.SH DESCRIPTION
Tidy reads HTML, XHTML and XML files and writes cleaned up markup.  For HTML variants, it detects and corrects many common coding errors and strives to produce visually equivalent markup that is both W3C complaint and works on most browsers. A common use of Tidy is to convert plain HTML to XHTML.  For generic XML files, Tidy is limited to correcting basic well-formedness errors and pretty printing.
.P
If no markup file is specified, Tidy reads the standard input.  If no output file is specified, Tidy writes markup to the standard output.  If no error file is specified, Tidy writes messages to the standard error.
.SH OPTIONS
<xsl:call-template name="show-cmdline-options" />
.SH USAGE
.P
Use \fB--\fR\fIoptionX valueX\fR for the any detailed configuration option "optionX" with the argument "valueX".  See also below under \fBDetailed Configuration Options\fR as to how to conveniently group all such options in a single config file.
.P
Input/Output default to stdin/stdout respectively. Single letter options apart from \fB-f\fR and \fB-o\fR may be combined as in:
.LP
.in 1i
\fBtidy -f errs.txt -imu foo.html\fR
.LP
For further info on HTML see \fIhttp://www.w3.org/MarkUp\fR.
.P
For more information about HTML Tidy, visit the project home page at \fIhttp://tidy.sourceforge.net\fR.  Here, you will find links to documentation, mailing lists (with searchable archives) and links to report bugs.
.SH ENVIRONMENT
.TP
.B HTML_TIDY
Name of the default configuration file.  This should be an absolute path, since you will probably invoke \fBtidy\fR from different directories.  The value of HTML_TIDY will be parsed after the compiled-in default (defined with -DCONFIG_FILE), but before any of the files specified using \fB-config\fR.
.SH "EXIT STATUS"
.IP 0
All input files were processed successfully.
.IP 1
There were warnings.
.IP 2
There were errors.
</xsl:template>


<xsl:template name="config-section">
.SH ______________________________
.SH "  "
.SH "DETAILED CONFIGURATION OPTIONS"
This section describes the Detailed (i.e., "expanded") Options, which may be specified by preceding each option with \fB--\fR at the command line, followed by its desired value, OR by placing the options and values in a configuration file, and telling tidy to read that file with the \fB-config\fR standard option.
.SH SYNOPSIS
\fBtidy --\fR\fIoption1 \fRvalue1 \fB--\fIoption2 \fRvalue2 [standard options ...]
.br
\fBtidy -config \fIconfig-file \fR[standard options ...]
.SH WARNING
The options detailed here do not include the "standard" command-line options (i.e., those preceded by a single '\fB-\fR') described above in the first section of this man page.
.SH DESCRIPTION
A list of options for configuring the behavior of Tidy, which can be passed either on the command line, or specified in a configuration file.
.P
A Tidy configuration file is simply a text file, where each option
is listed on a separate line in the form
.LP
.in 1i
\fBoption1\fR: \fIvalue1\fR
.br
\fBoption2\fR: \fIvalue2\fR
.br
etc.
.P
The permissible values for a given option depend on the option's \fBType\fR.  There are five types: \fIBoolean\fR, \fIAutoBool\fR, \fIDocType\fR, \fIEnum\fR, and \fIString\fR. Boolean types allow any of \fIyes/no, y/n, true/false, t/f, 1/0\fR.  AutoBools allow \fIauto\fR in addition to the values allowed by Booleans.  Integer types take non-negative integers.  String types generally have no defaults, and you should provide them in non-quoted form (unless you wish the output to contain the literal quotes).
.P
Enum, Encoding, and DocType "types" have a fixed repertoire of items; consult the \fIExample\fR[s] provided below for the option[s] in question.
.P
You only need to provide options and values for those whose defaults you wish to override, although you may wish to include some already-defaulted options and values for the sake of documentation and explicitness.
.P
Here is a sample config file, with at least one example of each of the five Types:
.P
\fI
    // sample Tidy configuration options
    output-xhtml: yes
    add-xml-decl: no
    doctype: strict
    char-encoding: ascii
    indent: auto
    wrap: 76
    repeated-attributes: keep-last
    error-file: errs.txt
\fR
.P
Below is a summary and brief description of each of the options. They are listed alphabetically within each category.  There are five categories: \fIHTML, XHTML, XML\fR options, \fIDiagnostics\fR options, \fIPretty Print\fR options, \fICharacter Encoding\fR options, and \fIMiscellaneous\fR options.
.P
.SH OPTIONS
<xsl:call-template name="show-config-options" />
</xsl:template>


<xsl:template name="show-cmdline-options">
.SS File manipulation
  <xsl:call-template name="cmdline-detail">
     <xsl:with-param name="category">file-manip</xsl:with-param>
  </xsl:call-template>
.SS Processing directives
  <xsl:call-template name="cmdline-detail">
     <xsl:with-param name="category">process-directives</xsl:with-param>
  </xsl:call-template>
.SS Character encodings
  <xsl:call-template name="cmdline-detail">
     <xsl:with-param name="category">char-encoding</xsl:with-param>
  </xsl:call-template>
.SS Miscellaneous
  <xsl:call-template name="cmdline-detail">
     <xsl:with-param name="category">misc</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template name="cmdline-detail">
<!--
For each option in one of the 3 categories/classes, provide its
    1. names
    2. description
    3. equivalent configuration option
-->
  <xsl:param name="category" />
    <xsl:for-each select='/cmdline/option[@class=$category]'>
<xsl:text>
.TP
</xsl:text>
       <xsl:call-template name="process-names" />
       <xsl:text>
</xsl:text>
       <xsl:apply-templates select="description" />
       <xsl:text>
</xsl:text>
       <xsl:call-template name="process-eqconfig" />
    </xsl:for-each>
</xsl:template>


<xsl:template name="process-names">
<!-- Used only in the cmdline section -->
  <xsl:for-each select="name">
    <xsl:text />\fB<xsl:value-of select="." />\fR<xsl:text />
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<xsl:template name="process-eqconfig">
<!-- Used only in the cmdline section -->
  <xsl:if test="string-length(eqconfig) &gt; 0">
   <xsl:for-each select="eqconfig">
     <xsl:text>(\fI</xsl:text>
     <xsl:value-of select="." />
     <xsl:text>\fR)</xsl:text>
   </xsl:for-each>
  </xsl:if>
</xsl:template>


<xsl:template name="show-config-options">
<!-- Used only in the cmdline section -->
.SS HTML, XHTML, XML options:
  <xsl:call-template name="config-detail">
     <xsl:with-param name="category">markup</xsl:with-param>
  </xsl:call-template>
.SS Diagnostics options:
  <xsl:call-template name="config-detail">
     <xsl:with-param name="category">diagnostics</xsl:with-param>
  </xsl:call-template>
.SS Pretty Print options:
  <xsl:call-template name="config-detail">
     <xsl:with-param name="category">print</xsl:with-param>
  </xsl:call-template>
.SS Character Encoding options:
  <xsl:call-template name="config-detail">
     <xsl:with-param name="category">encoding</xsl:with-param>
  </xsl:call-template>
.SS Miscellaneous options:
  <xsl:call-template name="config-detail">
     <xsl:with-param name="category">misc</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!--
    Note that any templates called implicitly or explicitly
    from the "config-detail" template below will match on
    the document referred to by the $CONFIG variable, i.e.,
    the file "tidy-config.xml", created by running

        tidy -xml-config > tidy-config.xml

    The $CONFIG variable is set at the top level of this
    stylesheet.
-->

<xsl:template name="config-detail">
<!--
For each option in one of the 5 categories/classes, provide its
    1. name
    2. type
    3. default (if any)
    4. example (if any)
    5. seealso (if any)
    6. description
-->
  <xsl:param name="category" />
    <xsl:for-each select='$CONFIG/config/option[@class=$category]'>
       <xsl:sort select="name" order="ascending" />
.P
\fB<xsl:apply-templates select="name" />\fR
.LP
.in 1i
Type:    \fI<xsl:apply-templates select="type" />\fR
.br
<xsl:call-template name="provide-default" />
.br
<xsl:call-template name="provide-example" />
.LP
.in 1i
<xsl:apply-templates select="description" />
<xsl:call-template name="seealso" />
    </xsl:for-each>
</xsl:template>


<!-- Used only in the config options section: -->
<xsl:template name="seealso">
  <xsl:if test="seealso">
.P
.rj 1
\fBSee also\fR: <xsl:text />
    <xsl:for-each select="seealso">
      <xsl:text />\fI<xsl:value-of select="." />\fR<xsl:text />
      <xsl:if test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>


<!-- Used only in the config options section: -->
<xsl:template name="provide-default">
<!--
Picks up the default from the XML.  If the `default` element
doesn't exist, or it's empty, a single '-' is provided.
-->
  <xsl:choose>
    <xsl:when test="string-length(default) &gt; 0 ">
      <xsl:text />Default: \fI<xsl:apply-templates
        select="default" />\fR<xsl:text />
    </xsl:when>
    <xsl:otherwise>
      <xsl:text />Default: \fI-\fR<xsl:text />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Used only in the config options section: -->
<xsl:template name="provide-example">
<!--
By default, doesn't output examples for String types (mirroring the
quickref page).  But for *any* options in the XML instance that
have an `example` child, that example will be used in lieu of a
stylesheet-provided one. (Useful e.g. for `repeated-attributes`).
-->
  <xsl:choose>
    <xsl:when test="string-length(example) &gt; 0">
      <xsl:text />Example: \fI<xsl:apply-templates
          select="example" />\fR<xsl:text />
    </xsl:when>
    <xsl:otherwise>
      <xsl:text />Default: \fI-\fR<xsl:text />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Called from the templates below matching `code`, `em`, `strong`: -->
<xsl:template name="escape-backslash">
<!--
Since backslashes are "special" to the *roff processors used
to generate man pages, we need to escape backslash characters
appearing in content with another backslash.
-->
  <xsl:choose>
    <xsl:when test="contains(.,'\')">
      <xsl:value-of select=
        "concat( substring-before(.,'\'), '\\', substring-after(.,'\') )" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Appears at the bottom of the man page: -->
<xsl:template name="manpage-see-also-section">
.SH "SEE ALSO"
HTML Tidy Project Page at \fIhttp://tidy.sourceforge.net\fR
.SH AUTHOR
\fBTidy\fR was written by Dave Raggett &lt;\fIdsr@w3.org\fR&gt;, and is now maintained and developed by the Tidy team at \fIhttp://tidy.sourceforge.net/\fR.  It is released under the \fIMIT Licence\fR.
.P
Generated automatically with HTML Tidy released on <xsl:value-of select="cmdline/@version" />.
</xsl:template>


<!-- Regular Templates: -->


<xsl:template match="description">
   <xsl:apply-templates />
</xsl:template>

<xsl:template match="a">
   <xsl:apply-templates />
   <xsl:text /> at \fI<xsl:value-of select="@href" />\fR<xsl:text />
</xsl:template>

<xsl:template match="code | em">
   <xsl:text />\fI<xsl:call-template name="escape-backslash" />\fR<xsl:text />
</xsl:template>

<xsl:template match="br">
   <xsl:text>
.br
</xsl:text>
</xsl:template>

<xsl:template match="strong">
   <xsl:text />\fB<xsl:call-template name="escape-backslash" />\fR<xsl:text />
</xsl:template>


<!--
The following templates
  a) normalize whitespace, primarily necessary for `description`
  b) do so without stripping possible whitespace surrounding `code`
  d) strip leading and trailing whitespace in 'description` and `code`
(courtesy of Ken Holman on the XSL-list):
-->

<xsl:template match="text()[preceding-sibling::node() and
                             following-sibling::node()]">
   <xsl:variable name="ns" select="normalize-space(concat('x',.,'x'))"/>
   <xsl:value-of select="substring( $ns, 2, string-length($ns) - 2 )" />
</xsl:template>

<xsl:template match="text()[preceding-sibling::node() and
                             not( following-sibling::node() )]">
   <xsl:variable name="ns" select="normalize-space(concat('x',.))"/>
   <xsl:value-of select="substring( $ns, 2, string-length($ns) - 1 )" />
</xsl:template>

<xsl:template match="text()[not( preceding-sibling::node() ) and
                             following-sibling::node()]">
   <xsl:variable name="ns" select="normalize-space(concat(.,'x'))"/>
   <xsl:value-of select="substring( $ns, 1, string-length($ns) - 1 )" />
</xsl:template>

<xsl:template match="text()[not( preceding-sibling::node() ) and
                             not( following-sibling::node() )]">
   <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

</xsl:stylesheet>
