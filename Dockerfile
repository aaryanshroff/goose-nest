# Amazon Linux 2 Distro
FROM public.ecr.aws/lambda/python:3.11

# Install helper deps
RUN yum -y update && \
  yum -y install unzip

# Install chromedriver
RUN curl -L "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.109/linux64/chromedriver-linux64.zip" -o "/tmp/chromedriver-linux64.zip" && \
  unzip /tmp/chromedriver-linux64.zip -d /opt/ && \
  mv /opt/chromedriver-linux64 /opt/chromedriver

# Install Chrome
RUN curl -L "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.109/linux64/chrome-linux64.zip" -o "/tmp/chrome-linux64.zip" && \
  unzip /tmp/chrome-linux64.zip -d /opt/ && \
  mv /opt/chrome-linux64 /opt/chrome

# Install Chrome deps
RUN yum -y install atk cups-libs gtk3 libXcomposite alsa-lib \
  libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
  libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
  xorg-x11-xauth dbus-glib dbus-glib-devel nss mesa-libgbm

COPY src/ ${LAMBDA_TASK_ROOT}

RUN pip install -r requirements.txt

CMD [ "lambda_function.lambda_handler" ]