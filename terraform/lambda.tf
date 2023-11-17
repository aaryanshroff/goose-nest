##############################################
# Goose Nest Scraper Lambda Layer
##############################################
resource "aws_lambda_layer_version" "goose_nest_scraper_lambda_layer" {
  filename   = local.goose_nest_scraper_lambda_layer_payload_path
  layer_name = "goose_nest_scraper_lambda_layer"

  compatible_runtimes = ["python3.11"]
}

##############################################
# Goose Nest Scraper Lambda Function
##############################################
data "archive_file" "goose_nest_scraper_lambda_function_payload" {
  output_path = "goose_nest_scraper_lambda_function_payload.zip"
  type = "zip"

  source_dir = "${path.module}/../src"
}

resource "aws_lambda_function" "goose_nest_scraper_lambda_function" {
  filename      = "goose_nest_scraper_lambda_function_payload.zip"
  function_name = "goose_nest_scraper_lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.goose_nest_scraper_lambda_function_payload.output_base64sha256

  runtime = "python3.11"

  layers = [ aws_lambda_layer_version.goose_nest_scraper_lambda_layer.arn ]

  depends_on = [ data.archive_file.goose_nest_scraper_lambda_function_payload ]
}