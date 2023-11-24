# Goose Nest Housing Bot

## Contributing

### Set up dev environment
```bash
$ source setup_dev.sh
```

### Testing the Lambda container image locally
1. Start the Docker daemon
2. ```bash
   $ pwd
   goose-nest
   $ ./scripts/build_and_run_image.sh
   ```
   This command runs the image as a container and creates a local endpoint at `localhost:9000/2015-03-31/functions/function/invocations`.
3. From a new terminal window, post an event to the local endpoint.
   ```bash
   $ curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
   ```