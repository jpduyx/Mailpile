FROM alpine:3.5

WORKDIR /Mailpile

# Add files 
ADD requirements.txt /Mailpile/requirements.txt
ADD packages/docker/entrypoint.sh /entrypoint.sh
ADD . /Mailpile

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

RUN pip install -r requirements.txt

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
# what is this?
CMD ./mp --www=0.0.0.0:33411 --wait
EXPOSE 33411
