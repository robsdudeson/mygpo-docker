FROM docker.io/library/debian:latest AS builder

ARG SSH_PRV_KEY
ARG SSH_PUB_KEY

ENV SSH_PRV_KEY=${SSH_PRV_KEY:-undefined}
ENV SSH_PUB_KEY=${SSH_PUB_KEY:-undefined}

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y \ 
    git \
    openssh-client

# ssh keys create
RUN mkdir ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan github.com > ~/.ssh/known_hosts

RUN echo "$SSH_PRV_KEY" > ~/.ssh/id && \
    echo "$SSH_PUB_KEY" > ~/.ssh/id.pub && \
    chmod 600 ~/.ssh/id && \
    chmod 600 ~/.ssh/id.pub

WORKDIR /app

RUN git clone git://github.com/gpodder/mygpo.git .

# ssh keys delete
RUN rm -rf ~/.ssh

CMD ["bash"]
