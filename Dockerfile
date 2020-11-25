ARG RUBY_VERSION
ARG NODE_VERSION
FROM ruby:${RUBY_VERSION}

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && \
	apt-get -yq install libpq-dev nodejs yarn

WORKDIR /app

COPY .package.json /app/package.json
RUN yarn && yarn build

COPY .Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app
RUN rails assets:precompile
