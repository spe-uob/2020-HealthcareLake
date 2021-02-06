/*
  IAM permissions for the glue crawler
*/
resource "aws_iam_role" "fhir_glue_role" {
  name = "${var.name_prefix}Role"

  assume_role_policy = aws_iam_role_policy.fhir_glue_policy
}
resource "aws_iam_role_policy" "fhir_glue_policy" {
  name = "${var.name_prefix}Policy"
  role = aws_iam_role.fhir_glue_role.id

  policy = aws_iam_policy_document.fhir_glue_policy_document
}
data "aws_iam_policy_document" "fhir_glue_policy_document" {
  // ...TODO
  statement {
    sid = "1"

    actions = [
      "kms:Decrypt",
      "dynamodb:DescribeTable",
      "dynamodb:Scan",
      "kms:DescribeKey"
    ]

    resources = [
      fhir_dynamodb
    ]
  }
}