module View.VideoScreen exposing (getEmbedYoutube, videoScreen)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Model exposing (Model)
import Utils exposing (getEmbedUrl, getKey)


videoScreen : Model -> Html msg
videoScreen model =
    case model.currentVideo of
        Nothing ->
            text ""

        Just vid ->
            let
                vidKey =
                    vid.link
                        |> getKey
            in
            getEmbedYoutube vidKey


getEmbedYoutube : Maybe String -> Html msg
getEmbedYoutube videoKey =
    case videoKey of
        Nothing ->
            text ""

        Just key ->
            div
                [ class "col-md-9" ]
                [ div [ class "embed-responsive embed-responsive-16by9" ]
                    [ iframe
                        [ class "iframe-video embed-responsive-item"
                        , attribute "allowfullscreen" ""
                        , src (getEmbedUrl key)
                        ]
                        []
                    ]
                ]
