FROM ruby:2.1.2

RUN echo 'deb http://archive.debian.org/debian/ jessie main' > /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian-security/ jessie/updates main' >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99insecure-repositories && \
    echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99insecure-repositories

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /usr/src/salva

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:1.17.3
RUN bundle install

COPY . .

ENTRYPOINT ["./script/docker-entrypoint-development"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
