FROM public.ecr.aws/lambda/python:3.11

RUN yum -y update && \
  yum -y install unzip

RUN curl -L "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/119.0.6045.105/linux64/chromedriver-linux64.zip" -o "/tmp/chromedriver-linux64.zip" && \
  curl -L "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/119.0.6045.105/linux64/chrome-linux64.zip" -o "/tmp/chrome-linux64.zip" && \
  unzip /tmp/chromedriver-linux64.zip -d /opt/ && \
  unzip /tmp/chrome-linux64.zip -d /opt/

COPY src/requirements.txt ${LAMBDA_TASK_ROOT}

RUN pip install -r requirements.txt

COPY src/lambda_function.py ${LAMBDA_TASK_ROOT}

CMD [ "lambda_function.lambda_handler" ]