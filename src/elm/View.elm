module View exposing (..)

import Html
    exposing
        ( div
        , Html
        , iframe
        , text
        , input
        , span
        , br
        )
import Html.Attributes
    exposing
        ( class
        , placeholder
        , src
        , value
        , type_
        , attribute
        )
import Html.Events exposing (onInput, onClick, onFocus)
import Update exposing (Msg)
import Model exposing (Model)
import Utils exposing (getKey, getEmbedUrl)
import Database exposing (Video)
import Update
    exposing
        ( Msg(..)
        )


-- View


isRelateVideo : String -> Video -> Bool
isRelateVideo query video =
    let
        lowerQuery =
            String.toLower query
    in
        [ video.title, video.speaker, video.id ]
            |> List.map String.toLower
            |> List.any (String.contains lowerQuery)


filterVideoList : String -> List Video -> List Video
filterVideoList query videoList =
    case String.isEmpty query of
        True ->
            videoList

        False ->
            videoList |> List.filter (isRelateVideo query)


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ div [ class "row" ]
            [ listView model
            , videoScreen model
            ]
        ]


listView : Model -> Html Msg
listView model =
    div [ class "list col-md-2" ]
        [ searchForm model
        , br [] []
        , videoListView model
        ]


searchForm : Model -> Html Msg
searchForm model =
    let
        glyphSearchIcon =
            span [ class "glyphicon glyphicon-search", attribute "aria-hidden" "true" ] []

        placeholder_text =
            if model.focus then
                "제목 혹은 발표자 검색"
            else
                "목록 보기"
    in
        div [ class "search-bar input-group input-group-lg", attribute "data-toggle" "collapse" ]
            [ span [ class "input-group-addon" ] [ glyphSearchIcon ]
            , input
                [ type_ "text"
                , class "form-control"
                , onInput InputQuery
                , onFocus FocusQuery
                , value model.query
                , placeholder placeholder_text
                ]
                []
            ]


videoListView : Model -> Html Msg
videoListView model =
    model.videoList
        |> filterVideoList model.query
        |> List.sortWith compareId
        |> List.map (videoSingleRowView model)
        |> div [ class "video-list list-group" ]


compareId : Video -> Video -> Order
compareId a b =
    case compare a.id b.id of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


videoSingleRowView : Model -> Video -> Html Msg
videoSingleRowView model video =
    let
        isActive =
            case model.currentVideo of
                Nothing ->
                    False

                Just vid ->
                    vid.id == video.id

        aClass =
            if isActive then
                "video-row list-group-item active"
            else
                "video-row list-group-item"

        hide =
            (not isActive) && (not model.focus)
    in
        case hide of
            True ->
                text ""

            False ->
                Html.a [ class aClass, onClick (ClickVideo video) ]
                    [ div [ class "video-title list-group-item-heading" ] [ text video.title ]
                    , div [ class "video-list-sub-heading" ] [ text video.id ]
                    , div [ class "video-speaker" ] [ text <| "발표자: " ++ video.speaker ]

                    -- , div [ class "video-link" ] [ text video.link ]
                    ]


videoScreen : Model -> Html Msg
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
                case vidKey of
                    Nothing ->
                        text ""

                    Just key ->
                        div [ class "screen col-md-10 embed-responsive embed-responsive-16by9" ]
                            [ iframe
                                [ class "iframe-video embed-responsive-item"
                                , attribute "frameborder" "0"
                                , attribute "allowfullscreen" ""
                                , src (getEmbedUrl key)
                                ]
                                []
                            ]
