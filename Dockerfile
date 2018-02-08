FROM ubuntu:16.04
EXPOSE 4000

# get up-to-date
RUN apt-get update \
    && apt-get -y upgrade

# install basic packages
RUN apt-get -y install \
    vim \
    wget \
    curl \
    apt-transport-https \
    inotify-tools

# niceties
RUN echo "syntax off" > ~/.vimrc &&\
    echo "alias ll='ls -alF'" >> ~/.bashrc

# elixir requires UTF-8
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install elixir & erlang
RUN echo "deb https://packages.erlang-solutions.com/ubuntu xenial contrib" > /etc/apt/sources.list.d/erlang-solutions.list
RUN wget https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc
RUN apt-key add erlang_solutions.asc
RUN apt-get update \
    && touch /etc/init.d/couchdb \
    && apt-get -y install elixir erlang

# cleanup after package installs
RUN apt-get clean

# install the phoenix mix archive
RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez
RUN mix local.rebar --force
