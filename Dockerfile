FROM alpine:3.15 as builder

ENV BUILD_PACKAGES bash curl curl-dev ruby-dev build-base
ENV RUBY_PACKAGES \
  ruby ruby-io-console ruby-irb \
  ruby-json ruby-etc ruby-bigdecimal ruby-rdoc \
  libffi-dev zlib-dev
ENV TERM=linux
ENV PS1 "\n\n>> ruby \W \$ "

RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES

RUN echo 'gem: --no-document' > /etc/gemrc && \
  gem install bundler

RUN bundle config --global silence_root_warning 1

COPY . /madness

RUN cd /madness && \
  gem build madness.gemspec --output=madness.gem && \
  gem install madness.gem && \
  cd / && \
  rm -rf /madness

FROM builder

WORKDIR /docs

EXPOSE 3000

ENTRYPOINT ["madness"]
