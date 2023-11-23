##############################################
# Goose Nest Scraper Python Layer
##############################################
resource "aws_lambda_layer_version" "goose_nest_scraper_python_layer" {
  filename   = local.goose_nest_scraper_python_layer_payload_path
  layer_name = "goose_nest_scraper_python_layer"
  source_code_hash = filebase64sha256(local.goose_nest_scraper_python_layer_payload_path)

  compatible_runtimes = ["python3.11"]

  skip_destroy = true
}

##############################################
# Goose Nest Scraper Chrome Layer
##############################################
resource "aws_lambda_layer_version" "goose_nest_scraper_chrome_layer" {
  filename   = local.goose_nest_scraper_chrome_layer_payload_path
  layer_name = "goose_nest_scraper_chrome_layer"
  source_code_hash = filebase64sha256(local.goose_nest_scraper_chrome_layer_payload_path)

  compatible_runtimes = ["python3.11"]

  skip_destroy = true
}

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

  layers = [ aws_lambda_layer_version.goose_nest_scraper_chrome_layer.arn, aws_lambda_layer_version.goose_nest_scraper_python_layer.arn ]

  depends_on = [ data.archive_file.goose_nest_scraper_lambda_function_payload ]
}