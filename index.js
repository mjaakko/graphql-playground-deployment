const express = require('express');
const fs = require('fs');

const port = process.env.PORT || 8080;

const html = fs.readFileSync('index.html').toString()

const app = express();

app.use(express.static('dist'));

app.use('/graphql-playground', (req, res) => {
  res.send(html.replace('__GRAPHQL__API__ENDPOINT__', 'https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql'));
});

app.listen(port, () => console.log('Started'));
