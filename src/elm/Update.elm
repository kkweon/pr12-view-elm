module Update exposing (..)

import Model exposing (Model)
import Database exposing (Video)


type Msg
    = InputQuery String
    | ClickVideo Video
    | FocusQuery


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputQuery query ->
            { model | query = query } ! []

        ClickVideo video ->
            { model | currentVideo = Just video, focus = False, query = "" } ! []

        FocusQuery ->
            { model | focus = True } ! []
