This XSLT was taken from https://github.com/xspec/xspec/blob/e4a1ca6a699304813f2384277784d5ebe7928222/src/reporter/coverage-report.xsl and modified slightly so that it
generates an HTML coverage report for any XSLT file, not just an XSpec file.

The changes were:

- retrieve the `stylesheet-uri` variable directly instead of loading the xspec file
- specify a local path for importing the utility packages