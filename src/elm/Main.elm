module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Database exposing (Video, videoList)
import Utils exposing (getKey, getEmbedUrl)

import View exposing (view)
import Update exposing (update)
import Model exposing (init)


main : Program Never Model.Model Update.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
