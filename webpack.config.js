const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");


const OUTPUT_DIR = "public"
module.exports = {
    entry: "./src/index.js",
    output: {
        path: path.resolve(__dirname, OUTPUT_DIR),
        filename: "bundle.js"
    },
    plugins: [new HtmlWebpackPlugin({
        title: "PR-12 Video Links",
        template: "./src/static/base.html",
        inject: "body"
    }), new ExtractTextPlugin("style.css")],
    module: {
        rules: [{
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: {
                    loader: "elm-webpack-loader",
                    options: {}
                }
            },
            {
                test: /\.css$/,
                use: ExtractTextPlugin.extract({
                    use: ["css-loader", "sass-loader"],
                    fallback: "style-loader"
                })
            },
            {
                test: /\.scss$/,
                use: ExtractTextPlugin.extract({
                    use: ["css-loader", "sass-loader"],
                    fallback: "style-loader"
                })
            }
        ]
    },
    devServer: {
        contentBase: path.join(__dirname, OUTPUT_DIR),
        compress: true,
        port: 9000,
        open: true,
    }
};
