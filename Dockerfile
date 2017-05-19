FROM alpine:3.5
RUN mkdir /Mailpile

WORKDIR /Mailpile

# Create users and groups
# [jpd: useless in kubernetes which runs as random user?]
# RUN addgroup -S mailpile && adduser -S -h /mailpile-data -G mailpile mailpile

# [WIP: jpd] added based on: https://docs.openshift.org/latest/creating_images/guidelines.html
RUN mkdir /mailpile-data && chgrp -R 0 /mailpile-data  /Mailpile  && chmod -R g+rwX /mailpile-data /Mailpile

# Install dependencies
RUN apk --no-cache add \
  ca-certificates \
  openssl \
  gnupg1 \
  py-pip \
  py-imaging \
  py-jinja2 \
  py-lxml \
  py-lockfile \
  py-pillow \
  py-pbr \
  py-cryptography

ADD requirements.txt /Mailpile/requirements.txt
RUN pip install -r requirements.txt

# Entrypoint
ADD packages/docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ./mp --www=0.0.0.0:33411 --wait
EXPOSE 33411

# Add code
ADD . /Mailpile
