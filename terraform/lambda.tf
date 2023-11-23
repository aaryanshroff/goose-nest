##############################################
# Goose Nest Scraper Lambda Function
##############################################
data "archive_file" "goose_nest_scraper_lambda_function_payload" {
  output_path = local.goose_nest_scraper_lambda_function_payload_path
  type = "zip"

  source_dir = "${path.module}/../src"
}

resource "aws_lambda_function" "goose_nest_scraper_lambda_function" {
  filename      = local.goose_nest_scraper_lambda_function_payload_path
  function_name = "goose_nest_scraper_lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 60

  source_code_hash = data.archive_file.goose_nest_scraper_lambda_function_payload.output_base64sha256

  runtime = "python3.11"

  depends_on = [ data.archive_file.goose_nest_scraper_lambda_function_payload ]
}