docker build --platform linux/amd64 -t docker-image:test .

docker run -p 9000:8080 docker-image:test
