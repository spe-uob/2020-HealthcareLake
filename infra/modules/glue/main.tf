/*
  Stage 1: DynamoDB->Glue->S3
*/
resource "aws_glue_catalog_database" "fhir_catalog" {
  name = "fhir_db_catalog"
}

resource "aws_glue_crawler" "fhir_db_crawler" {
  database_name = aws_glue_catalog_database.fhir_catalog.name
  name          = "${var.name_prefix}Crawler"
  role          = aws_iam_role.crawler_role.arn

  dynamodb_target {
    path = var.fhir_db_name
  }
}

resource "aws_glue_job" "fhir_etl" {
  name     = "${var.name_prefix}ETL"
  role_arn = aws_iam_role.job_role.arn

  command {
    script_location = "s3://${var.glue_script_path}"
  }

  default_arguments = {
    "--extra-py-files" = var.glue_library_path
  }

  non_overridable_arguments = {
    "DB_NAME" = aws_glue_catalog_database.fhir_catalog.name
    "TBL_NAME" = var.fhir_db_name
    "OUT_DIR" = "s3://${var.lake_bucket}/datamart/"
  }
}


resource "aws_glue_workflow" "lake_ingestion" {
  name = "${var.name_prefix}Ingestion"
}

resource "aws_glue_trigger" "fhir_trigger" {
  name = "${var.name_prefix}Trigger"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.fhir_etl.name
    arguments = {
      "--extra-py-files" = var.glue_library_path
    }
  }
}

/*
  Stage 2: S3->Glue(->Athena)
*/
resource "aws_glue_catalog_database" "lake_catalog_table" {
  name = "lake_catalog"
}

resource "aws_glue_crawler" "lake_crawler" {
  database_name = aws_glue_catalog_database.lake_catalog_table.name
  name = "lake_crawler"
  role = aws_iam_role.crawler_role.arn

  s3_target {
    path = var.lake_bucket
  }
}