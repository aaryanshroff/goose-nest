# Goose Nest Housing Bot

## Contributing

### Set up dev environment
```bash
$ source setup_dev.sh
```

### Test Lambda layer locally
```bash
$ pwd
goose-nest
$ ./scripts/create_scraper_lambda_layer_payload.sh -r src/requirements.txt -p goose_nest_scraper_python_layer_payload.zip -c goose_nest_scraper_chrome_layer_payload.zip
```