FROM ruby:2.4-alpine

# Copy gem files
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Set workdir
WORKDIR /app

# Install dependencies
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        g++ \
        musl-dev \
        make \
        postgresql-dev \
    && apk add --no-cache libpq \
    && bundle install \
    && apk del .build-deps

# Expose the ruby port
EXPOSE 5000

# Add other files
COPY . /app
