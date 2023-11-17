# So that we can conditionally create a new lambda layer payload if requirements.txt changes
data "local_file" "requirements_dot_txt" {
  filename = "../src/requirements.txt"
}

resource "null_resource" "goose_nest_scraper_lambda_layer_payload" {
  triggers = {
    # Trigger the script execution only if the hash of requirements.txt changes
    file_changed = md5(data.local_file.requirements_dot_txt.content)
  }

  provisioner "local-exec" {
    command = "./scripts/create_lambda_layer_payload.sh src/requirements.txt goose_nest_scraper_lambda_layer_payload.zip"
  }
}

resource "aws_lambda_layer_version" "goose_nest_scraper_lambda_layer" {
  filename   = "goose_nest_scraper_lambda_layer_payload.zip"
  layer_name = "goose_nest_scraper_lambda_layer"

  compatible_runtimes = ["python3.11"]

  depends_on = [null_resource.goose_nest_scraper_lambda_layer_payload]
}