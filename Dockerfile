# SigPloit - Telecom Signaling Exploitation Framework

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        python2.7 \
        python-pip \
        python-dev \
        default-jre-headless \
        lksctp-tools \
        libsctp-dev \
        build-essential \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --depth 1 https://github.com/SigPloiter/SigPloit.git

WORKDIR /opt/SigPloit
RUN pip2 install --no-cache-dir setuptools

# requirements.txt pins pyfiglet as "pyfiglet>=0.7.5"
RUN sed -i 's/^pyfiglet.*/pyfiglet==0.7.5/' requirements.txt \
    && pip2 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python2.7", "sigploit.py"]