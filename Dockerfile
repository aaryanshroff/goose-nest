# Amazon Linux 2 Distro
FROM public.ecr.aws/lambda/python:3.11

# Install common deps
RUN yum -y update && \
  yum -y install tar gzip bzip2 gtk3 alsa-lib

# Install gecko driver (Firefox driver)
RUN curl -L "https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz" -o "/tmp/geckodriver-v0.33.0-linux64.tar.gz" && \
  tar -xf /tmp/geckodriver-v0.33.0-linux64.tar.gz -C /opt/

# Install Firefox
# TODO: Figure out how to pin to specific version
RUN curl -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-CA" -o "/tmp/firefox.tar.bz2" && \
  tar -xf /tmp/firefox.tar.bz2 -C /opt/

COPY src/ ${LAMBDA_TASK_ROOT}

RUN pip install -r requirements.txt

CMD [ "lambda_function.lambda_handler" ]