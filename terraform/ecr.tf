resource "aws_ecr_repository" "goose_nest_scraper_ecr_repository" {
  name                 = "goose_nest_scraper_ecr_repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}