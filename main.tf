provider "aws" {
  region = "us-east-1"  # Set to the desired AWS region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "DijayLambdaFunction"
  
  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = "lambda/my_lambda_function.zip"
  
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  
  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      ENV_VAR = "value"  # Optional, you can define environment variables for Lambda
    }
  }
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "Dijay-lambda-deployment-bucket-12345"  # Change to a globally unique name
}

resource "aws_s3_bucket_object" "lambda_object" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambda/my_lambda_function.zip"
  source = "lambda/my_lambda_function.zip"  # Local path to your zipped Lambda code
  acl    = "private"
}
