import WebpackNotifierPlugin from 'webpack-notifier';
import CopyWebpackPlugin from 'copy-webpack-plugin';
import ExtractTextPlugin from 'extract-text-webpack-plugin';
import webpack from 'webpack';
import path from 'path';

require('dotenv').config();

const envVars = ['NODE_ENV', 'API_KEY'];

const isProd = process.env.NODE_ENV === 'production';
console.log(
  isProd ? 'Building for Production ⚡️': 'Building for Development 💃'
);

const elmLoader = {
  loader: 'elm-webpack-loader',
  query : {
    verbose   : true,
    warn      : true,
    pathToMake: 'node_modules/.bin/elm-make'
  }
};

const config = {
  entry: './src/index.js',

  output: {
    path      : path.join(__dirname, '/build'),
    filename  : 'app.js',
    publicPath: '/'
  },

  devServer: {
    inline            : true,
    hot               : true,
    contentBase       : 'public',
    stats             : 'errors-only',
    historyApiFallback: true
  },

  module: {
    loaders: [
      {
        test   : /\.js$/,
        enforce: 'pre',
        loaders: ['eslint-loader'],
        exclude: [/node_modules/]
      },
      {
        test   : /\.js$/,
        exclude: /node_modules/,
        loaders: ['babel-loader']
      },
      {
        test  : /\.(css|scss)$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use     : [
            'css-loader',
            {
              loader : 'postcss-loader',
              options: {
                config: { path: './postcss.config.js' }
              }
            },
            'sass-loader'
          ]
        })
      },
      {
        test   : /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ['elm-hot-loader', elmLoader]
      },
      {
        test   : /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loaders: {
          loader : 'url-loader',
          options: {
            limit   : 10000,
            mimetype: 'application/font-woff'
          }
        }
      },
      {
        test   : /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader : 'url-loader',
        options: {
          limit   : 10000,
          mimetype: 'application/octet-stream'
        }
      },
      {
        test  : /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'file-loader'
      },
      {
        test   : /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader : 'url-loader',
        options: {
          limit   : 10000,
          mimetype: 'image/svg+xml'
        }
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin('app.css'),
    new CopyWebpackPlugin([{ from: './public' }]),
    new webpack.LoaderOptionsPlugin({
      options: {
        noParse: [/\.elm$/]
      }
    }),
    new webpack.EnvironmentPlugin(envVars)
  ]
};

if (isProd) {
  config.devServer = {};
  config.devtool   = '';
  config.plugins   = config.plugins.concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false
      }
    }),
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ]);
} else {
  config.devtool     = 'inline-source-map';
  config.plugins     = config.plugins.concat([new WebpackNotifierPlugin()]);
  config.performance = {
    hints: false
  };
}

module.exports = config;
