FROM ruby:3.2.1-alpine
LABEL maintainer="dani@danirod.es"

# Build variables
ENV BUNDLE_PATH=/vendor/bundle
ENV NODE_ENV=production
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=placeholder

# Install dependencies.
RUN apk add --update --no-cache file postgresql-dev gcompat imagemagick nodejs tzdata

# Initializes the working directory.
RUN mkdir /makigas
WORKDIR /makigas

# Install Ruby dependencies
ADD Gemfile Gemfile.lock /
RUN apk add --update --no-cache build-base && \
    gem install bundler:2.4.7 && \
    bundle config set no-cache 'true' && \
    bundle config set without 'development test' && \
    bundle install && \
    rm -rf /vendor/bundle/ruby/3.2.0/cache/*.gem && \
    find /vendor/bundle/ruby/3.2.0/gems/ -name "*.[co]" -delete && \
    apk del build-base

ADD . .
RUN apk add --no-cache yarn && \
    yarn install --check-files && \
    bin/rails assets:precompile && \
    rm -rf node_modules && \
    yarn cache clean && \
    apk del yarn

CMD ["docker/rails_start.sh"]
