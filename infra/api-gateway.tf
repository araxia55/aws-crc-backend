data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "counter.py"
  output_path = "counter.zip"
}

resource "aws_lambda_function" "crc_visitor_counter" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "visitor-counter"
  role          = aws_iam_role.lambda_role.arn
  handler       = "counter.handler"
  runtime       = "python3.9"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = <<-EOF
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

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_role.name
}


# API Gateway
resource "aws_api_gateway_rest_api" "visitor_counter" {
  name = "visitor-counter"
}

resource "aws_api_gateway_resource" "visitor_counter" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  parent_id   = aws_api_gateway_rest_api.visitor_counter.root_resource_id
  path_part   = "count"
}

# API Method
resource "aws_api_gateway_method" "visitor_counter" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  resource_id   = aws_api_gateway_resource.visitor_counter.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate the API Gateway to the Lambda function:
resource "aws_api_gateway_integration" "visitor_counter" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_counter.id
  resource_id             = aws_api_gateway_resource.visitor_counter.id
  http_method             = aws_api_gateway_method.visitor_counter.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.crc_visitor_counter.invoke_arn
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crc_visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.visitor_counter.execution_arn}/*/GET/count"
}


# Deploy the API Gateway
resource "aws_api_gateway_deployment" "visitor_counter" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_integration.visitor_counter))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "visitor_counter" {
  deployment_id = aws_api_gateway_deployment.visitor_counter.id
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  stage_name    = "crc-prod"
}

