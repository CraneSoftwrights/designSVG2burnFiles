if [ ! -f utilities/xslstyle/xslstyle-docbook.xsl ] || \
   [ ! -f utilities/saxon655/saxon.jar ]
then
echo Expecting the XSLStyle documentation subsystem is installed in the
echo utilities/xslstyle/ directory: https://github.com/CraneSoftwrights/xslstyle and
echo expecting the Saxon 6.5.5 XSLT 1 processor is installed in the
echo utilities/saxon655/ directory:
echo https://sourceforge.net/projects/saxon/files/saxon6/6.5.5/
exit 1
fi

if [ -f designSVG2burnFiles.html ]; then rm designSVG2burnFiles.html ; fi
if [ -f convertBadStrokes4designSVG.html ]; then rm convertBadStrokes4designSVG.html ; fi

echo Making designSVG2burnFiles.html
java -jar utilities/saxon655/saxon.jar -a -o designSVG2burnFiles.html designSVG2burnFiles.xsl
if [ $? -ne 0 ]; then
  echo Problem executing Saxon for designSVG2burnFiles.html
  exit 1
fi
if [ ! -f designSVG2burnFiles.html ]; then
  echo "Error: Documentation designSVG2burnFiles.html not produced"
  exit 1
fi
grep -q -i "inconsistencies.detected" designSVG2burnFiles.html
retdesign=$?
if [ $retdesign -eq 0 ]; then
  echo "Error: The file designSVG2burnFiles.html contains inconsistencies."
fi

echo Making convertBadStrokes4designSVG.html
java -jar utilities/saxon655/saxon.jar -a -o convertBadStrokes4designSVG.html convertBadStrokes4designSVG.xsl
if [ $? -ne 0 ]; then
  echo Problem executing Saxon for convertBadStrokes4designSVG.html
  exit 1
fi
if [ ! -f convertBadStrokes4designSVG.html ]; then
  echo "Error: Documentation convertBadStrokes4designSVG.html not produced"
  exit 1
fi
grep -q -i "inconsistencies.detected" convertBadStrokes4designSVG.html
retconvert=$?
if [ $retconvert -eq 0 ]; then
  echo "Error: The file convertBadStrokes4designSVG.html contains inconsistencies."
fi

if [ $retconvert -eq 0 ] || [ $retdesign -eq 0 ]; then
  exit 1
fi

echo Documentation created successfully
