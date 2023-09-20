const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

app.use('/proxy', createProxyMiddleware({ 
  target: 'http://localhost:3000', // これをプロキシしたいウェブサイトのURLに置き換える
  changeOrigin: true,
  headers: {
    'Access-Control-Allow-Origin': '*',
  },
}));

app.listen(3000, () => {
  console.log('Proxy server running on http://localhost:3000');
});
