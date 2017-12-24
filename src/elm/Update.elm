module Update exposing (..)

import Model exposing (Model)
import Database exposing (Video)


type Msg
    = InputQuery String
    | ClickVideo Video
    | FocusQuery
    | ClearInput
    | OnKeyDown Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputQuery query ->
            { model | query = query } ! []

        ClickVideo video ->
            { model | currentVideo = Just video, focus = False } ! []

        ClearInput ->
            { model | query = "" } ! []

        FocusQuery ->
            { model | focus = True } ! []

        OnKeyDown key ->
            if key == 27 then
                { model | query = "" } ! []
            else
                model ! []
