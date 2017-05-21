FROM alpine:3.5

RUN mkdir -p /Mailpile
WORKDIR /Mailpile


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

COPY requirements.txt /Mailpile/requirements.txt
RUN pip install -r requirements.txt

# Entrypoint
COPY packages/docker/entrypoint.sh /entrypoint.sh
COPY . /Mailpile
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 33411

# Ownership  rootgroup for kubernetes
RUN mkdir /.local  /mailpile-data && chgrp -R 0 /.local /mailpile-data  /Mailpile  && chmod -R g+rwX /.local /mailpile-data /Mailpile

