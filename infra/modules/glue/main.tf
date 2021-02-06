/*
  Stage 1: DynamoDB->Glue->S3
*/
resource "aws_glue_catalog_database" "fhir_catalog" {
  name = "${var.name_prefix}CatalogDatabase"
}

resource "aws_glue_crawler" "fhir_db_crawler" {
  database_name = aws_glue_catalog_database.fhir_catalog.name
  name = "${var.name_prefix}Crawler"
  role = aws_iam_role.fhir_glue_role.arn
  
  dynamodb_target {
    path = fhir_dynamodb
  }
}

resource "aws_glue_job" "fhir_etl" {
  name  = "${var.name_prefix}ETL"
  //...TODO:
}

resource "aws_glue_trigger" "fhir_trigger" {
  name = "${var.name_prefix}Trigger"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.fhir_etl.name
  }
}

/*
  Stage 2: S3->Glue(->Athena)
*/
resource "aws_glue_catalog_table" "lake_catalog_table" {
  // TODO:
}

resource "aws_glue_crawler" "lake_crawler" {
  // TODO:

  s3_target {

  }
}