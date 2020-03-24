xsl_file=$1
input_file=$2
output_file=$3

if [[ ${output_file} != '' ]]; then
  saxon "-xsl:${xsl_file}" "-s:${input_file}" "-o:${output_file}"
else
  saxon "-xsl:${xsl_file}" "-s:${input_file}"
fi
