##############################################
# Goose Nest Scraper Lambda layer
##############################################

# So that we can conditionally create a new lambda layer payload if requirements.txt changes
data "local_file" "requirements_dot_txt" {
  filename = "../src/requirements.txt"
}

resource "null_resource" "create_goose_nest_scraper_lambda_layer_payload" {
  triggers = {
    # Trigger the script execution only if the hash of requirements.txt changes
    file_changed = md5(data.local_file.requirements_dot_txt.content)
  }

  provisioner "local-exec" {
    command = "${path.module}/../scripts/create_lambda_layer_payload.sh -r src/requirements.txt -o ${local.goose_nest_scraper_lambda_layer_payload_path}"
  }
}

resource "aws_lambda_layer_version" "goose_nest_scraper_lambda_layer" {
  filename   = local.goose_nest_scraper_lambda_layer_payload_path
  layer_name = "goose_nest_scraper_lambda_layer"

  compatible_runtimes = ["python3.11"]

  depends_on = [null_resource.goose_nest_scraper_lambda_layer_payload]
}

# Clean up payload zip file
resource "null_resource" "cleanup_goose_nest_scraper_lambda_layer_payload" {
  depends_on = [aws_lambda_layer_version.goose_nest_scraper_lambda_layer]

  provisioner "local-exec" {
    command = "rm -rf ${local.goose_nest_scraper_lambda_layer_payload_path}"
  }
}