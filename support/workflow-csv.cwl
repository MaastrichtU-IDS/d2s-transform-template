#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: Data2Services CWL workflow, Vincent Emonet <vincent.emonet@gmail.com> 


inputs: 
  
  working_directory: string 
  dataset: string

  input_data_jdbc: string
  r2rml_trig_file_name: string
  r2rml_trig_file: string

  input_data: string
  base_uri: string
  tmp_graph_uri: string

  rq_file_name: string
  r2rml_config_content: string

  param_config_file: string
  param_rq_file: string

  upload_method: string
  triplestore_url: string
  triplestore_repository: string

  sparql_queries_path: string
  sparql_endpoint: string
  sparql_username: string
  sparql_password: string
  output_graph_uri: string

outputs:
  
  trig_file_output:
    type: File
    outputSource: step1/trig_file_output
  r2rml_config_file_output:
    type: File
    outputSource: step2/r2rml_config_file_output
  rq_file_output:
    type: File
    outputSource: step3/rq_file_output
  graphdb_file_output:
    type: File
    outputSource: step4/graphdb_file_output

steps:

  step1:
    run: cwl-steps/autor2rml.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      input_data_jdbc: input_data_jdbc
      r2rml_trig_file_name: r2rml_trig_file_name
      r2rml_trig_file: r2rml_trig_file
      input_data: input_data
      base_uri: base_uri
      tmp_graph_uri: tmp_graph_uri
    out: [trig_file_output]

  step2:
    run: cwl-steps/generate-r2rml-config.cwl
    in:
      dataset: dataset
      input_data_jdbc: input_data_jdbc
      r2rml_trig_file: step1/trig_file_output
      rq_file_name: rq_file_name
      r2rml_config_content: r2rml_config_content
    out: [r2rml_config_file_output]

  step3:
    run: cwl-steps/run-r2rml.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      rq_file_name: rq_file_name
      r2rml_trig_file: step1/trig_file_output
      r2rml_config_file: step2/r2rml_config_file_output
      param_config_file: param_config_file
    out: [rq_file_output]


  step4:
    run: cwl-steps/rdf-upload.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      rq_file: step3/rq_file_output
      param_rq_file: param_rq_file
      upload_method: upload_method
      triplestore_url: triplestore_url
      triplestore_repository: triplestore_repository
    out: [graphdb_file_output]

  step6:
    run: cwl-steps/execute-sparql-mapping.cwl
    in:
      working_directory: working_directory
      dataset: dataset
      sparql_queries_path: sparql_queries_path
      sparql_endpoint: sparql_endpoint
      sparql_username: sparql_username
      sparql_password: sparql_password
      output_graph_uri: output_graph_uri
      graphdb_file: step4/graphdb_file_output
    out: [eow]
