const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
    entry: "./src/index.js",
    output: {
        path: path.resolve(__dirname, "public"),
        filename: "bundle.js"
    },
    plugins: [new HtmlWebpackPlugin({
        title: "PR-12 Video Links",
        filename: "index.html"
    })],
    module: {
        rules: [{
            test: /\.elm$/,
            exclude: [/elm-stuff/, /node_modules/],
            use: {
                loader: "elm-webpack-loader",
                options: {}
            }
        }]
    }
};
