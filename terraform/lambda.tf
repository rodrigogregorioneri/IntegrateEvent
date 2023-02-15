// Create archives for AWS Lambda functions which will be used for Step Function

data "archive_file" "build-lambda-a" {
  type        = "zip"
  output_path = "../lambdas/lambdaA/buildA.zip"
  source_file = "../lambdas/lambdaA/index.js"
}

data "archive_file" "build-lambda-b" {
  type        = "zip"
  output_path = "../lambdas/lambdaB/buildB.zip"
  source_file = "../lambdas/lambdaB/index.js"
}

// Create IAM role for AWS Lambda

resource "aws_iam_role" "iam_lambdas" {
  name = "stepFunctionLambdasIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// Create AWS Lambda functions

resource "aws_lambda_function" "lambdaA" {
  filename         = "../lambdas/lambdaA/buildA.zip"
  function_name    = "step-functions-lambda-a"
  role             = "${aws_iam_role.iam_lambdas.arn}"
  handler          = "index.handler"
  runtime          = "nodejs16.x"
}

resource "aws_lambda_function" "lambdaB" {
  filename         = "../lambdas/lambdaB/buildB.zip"
  function_name    = "step-functions-lambda-b"
  role             = "${aws_iam_role.iam_lambdas.arn}"
  handler          = "index.handler"
  runtime          = "nodejs16.x"
}
