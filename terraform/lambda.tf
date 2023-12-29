resource "aws_lambda_function" "goose_nest_scraper_lambda_function" {
  function_name = "goose_nest_scraper_lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  timeout       = 60

  image_uri    = "${aws_ecr_repository.goose_nest_scraper_ecr_repository.repository_url}:latest"
  package_type = "Image"

  environment {
    variables = {
      APP = "production"
    }
  }
}
