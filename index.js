const express = require('express');
const fs = require('fs');

const port = process.env.PORT || 8080;

const html = fs.readFileSync('index.html').toString()

const app = express();

const getDigitransitUrl = (config) => {
  return "https://api.digitransit.fi/routing/v1/routers/" + config + "/index/graphql";
}

const url = (config) => (process.env.ENDPOINT || getDigitransitUrl(config));

app.use(express.static('dist'));

app.use('/graphql-playground/:config', (req, res) => {
  res.send(html.replace('__GRAPHQL__API__ENDPOINT__', url(req.params.config)));
});

app.use('/graphql-playground', (req, res) => {
  res.redirect('/graphql-playground/hsl');
});

app.listen(port, () => console.log('Started'));
