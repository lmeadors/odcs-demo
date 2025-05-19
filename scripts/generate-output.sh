#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

mkdir -p output/ecommerce/avro
mkdir -p output/ecommerce/graphql

find source/odcs/ecommerce/ -name "*.yml" -print0 | while IFS= read -r -d $'\0' input_file; do
  echo "Processing \"${input_file}\""
  filename=$(basename -- "${input_file}")
  filename_no_ext="${filename%.*}"
  final_output_name="${filename_no_ext%-odcs}"
  avro_output_file="output/ecommerce/avro/${final_output_name}.avsc"
  graphql_output_file="output/ecommerce/graphql/${final_output_name}.graphql"

  datacontract export \
    --output "${avro_output_file}" --format avro  \
    "${input_file}"

  datacontract export \
    --format custom --template source/templates/data-contract-to-graphql.j2 \
    --output "${graphql_output_file}" "${input_file}"

done
