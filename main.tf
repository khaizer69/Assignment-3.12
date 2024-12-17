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
  function_name = "khaiLambdaFunction"
  
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  
  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      ENV_VAR = "value"  # Optional, you can define environment variables for Lambda
    }
  }
}
