module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Styled exposing (toUnstyled)
import Model exposing (init)
import Update exposing (update)
import View exposing (view)


type alias Flags =
    Int


main : Program Flags Model.Model Update.Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \_ -> Sub.none
        }
