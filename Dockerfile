FROM ruby:2.3.4
# support for additional https repositories
RUN apt-get update -qq && apt-get install -y apt-transport-https
# yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# nodejs 6.x repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
# install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn
# prepare
RUN mkdir /misgastos
WORKDIR /misgastos
# install project dependencies
ADD Gemfile /misgastos/Gemfile
ADD Gemfile.lock /misgastos/Gemfile.lock
RUN bundle install
# frontend dependencies
ADD package.json /misgastos/package.json
ADD yarn.lock /misgastos/yarn.lock
RUN yarn install
# add everything here to the image
ADD . /misgastos
