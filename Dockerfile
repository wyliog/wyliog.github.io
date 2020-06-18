FROM jekyll/jekyll:3.7.3
ADD Gemfile /srv/jekyll
ADD package.json  /srv/jekyll
RUN cd /srv/jekyll/ && bundle update 

ENTRYPOINT ["/usr/jekyll/bin/entrypoint"]