module Update exposing (Msg(..), update)

import Database exposing (Video)
import Model exposing (Model)


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
            ( { model | query = query }, Cmd.none )

        ClickVideo video ->
            ( { model | currentVideo = Just video, focus = False }
            , Cmd.none
            )

        ClearInput ->
            ( { model | query = "" }
            , Cmd.none
            )

        FocusQuery ->
            ( { model | focus = True }
            , Cmd.none
            )

        OnKeyDown key ->
            if key == 27 then
                ( { model | query = "" }
                , Cmd.none
                )

            else
                ( model
                , Cmd.none
                )
