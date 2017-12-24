module Main exposing (..)

import Html exposing (..)
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
