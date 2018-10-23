FROM node:10.12.0-alpine

WORKDIR graphql-playground-deployment

RUN apk add git

RUN apk add python
RUN apk add build-base

ADD .git ./.git
ADD graphql-playground ./graphql-playground
ADD build.sh index.js index.html package.json yarn.lock ./

RUN ls
RUN ./build.sh

RUN yarn

ENV PORT=8080
EXPOSE 8080

CMD ["node", "index.js"]
