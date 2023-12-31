docker build --platform linux/amd64 -t docker-image:test .

aws ecr get-login-password --region us-east-1 |
  docker login --username AWS --password-stdin 281808852508.dkr.ecr.us-east-1.amazonaws.com

docker tag docker-image:test 281808852508.dkr.ecr.us-east-1.amazonaws.com/goose_nest_scraper_ecr_repository:latest

docker push 281808852508.dkr.ecr.us-east-1.amazonaws.com/goose_nest_scraper_ecr_repository:latest

aws lambda update-function-code --function-name goose_nest_scraper_lambda_function --image-uri 281808852508.dkr.ecr.us-east-1.amazonaws.com/goose_nest_scraper_ecr_repository:latest
