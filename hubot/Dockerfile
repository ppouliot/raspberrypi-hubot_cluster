FROM arm32v6/node:latest
MAINTAINER Peter J. Pouliot <peter@pouliot.net>

RUN \
    /usr/bin/npm install -g yo generator-hubot \
    md /hubot \
    cd /hubot \
    yo hubot --owner='Peter J. Pouliot <peter@pouliot.net>' --name="Hubot" --description="Hubot in NanonServer Container" --adapter=slack --defaults ; \
    /usr/bin/npm install \
    css-select \
    css-what \
    minimatch \
    uuid \
    hubot-jenkins-enhanced \
    hubot-github \
    hubot-ghe \
    hubot-ghe-backup-snapshot \
    hubot-ghe-external-auto \
    hubot-ghe-external \
    hubot-ghe-failure-recovery'; \
    /usr/bin/npm uninstall hubot-heroku-keepalive' ; \
    rm -Force /hubot/hubot-scripts.json

COPY external-scripts.json /hubot/external-scripts.json
COPY hubot-start.ps1 /hubot/hubot-start.ps1
COPY Dockerfile /Dockerfile
# Run the hubot and expose the ports
EXPOSE 8080
WORKDIR c:/hubot
CMD bin/hubot --adapter slack
