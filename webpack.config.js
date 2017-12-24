const webpack = require("webpack");
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const OUTPUT_DIR = "public";

module.exports = {
  entry: "./src/index.js",
  output: {
    path: path.resolve(__dirname, OUTPUT_DIR),
    filename: "bundle.js",
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: "PR-12 Video Links",
      template: "./src/static/base.html",
      inject: "body",
    }),
    new ExtractTextPlugin("style.css"),

    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery",
      Popper: ["popper.js", "default"],
    }),
  ],
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader",
          options: {},
        },
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          use: ["css-loader", "postcss-loader", "sass-loader"],
          fallback: "style-loader",
        }),
      },
      {
        test: /\.(woff|woff2|ttf|eot|svg)(\?v=[a-z0-9]\.[a-z0-9]\.[a-z0-9])?$/,
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 10000,
            },
          },
        ],
      },
    ],
  },
  devServer: {
    contentBase: path.join(__dirname, OUTPUT_DIR),
    compress: true,
    port: 9000,
    open: true,
  },
};
