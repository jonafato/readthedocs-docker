FROM ubuntu:14.04
MAINTAINER Jon Banafato <jon@jonafato.com>

ENV DEBIAN_FRONTEND noninteractive

EXPOSE 8000

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libxml2-dev \
    libxslt1-dev \
    python-dev \
    python-pip \
    python-virtualenv \
    redis-server \
    texlive \
    texlive-latex-extra \
    zlib1g-dev

RUN git clone https://github.com/rtfd/readthedocs.org.git
WORKDIR /readthedocs.org

# Check out latest commit at the time of creating this file
RUN git checkout 140a970cb18ad0ee82739c351db0e55c9ed0915e
RUN virtualenv venv
RUN venv/bin/pip install \
    -r requirements/onebox.txt \
    --find-links deploy/wheels

RUN venv/bin/python readthedocs/manage.py syncdb --noinput
RUN venv/bin/python readthedocs/manage.py migrate

CMD ["venv/bin/python", "readthedocs/manage.py", "runserver", "0.0.0.0:8000"]
