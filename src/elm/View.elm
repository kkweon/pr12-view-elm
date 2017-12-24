module View exposing (..)

import Html
    exposing
        ( div
        , Html
        , iframe
        , text
        , input
        , button
        , span
        , br
        )
import Html.Attributes
    exposing
        ( class
        , placeholder
        , src
        , value
        , style
        , type_
        , attribute
        )
import Html.Events exposing (onInput, onClick, onFocus, on, keyCode)
import Json.Decode as Json
import Update exposing (Msg)
import Model exposing (Model)
import Utils exposing (getKey, getEmbedUrl)
import Database exposing (Video)
import Update
    exposing
        ( Msg(..)
        )


-- View


{-| If Video contains query in the title or speaker or id, return True
-}
isRelateVideo : String -> Video -> Bool
isRelateVideo query video =
    let
        lowerQuery =
            query
                |> String.trim
                |> String.toLower
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
        [ div [ class "row mt-3" ]
            [ listView model
            , videoScreen model
            ]
        ]


listView : Model -> Html Msg
listView model =
    div [ class "col-md-3 mb-3" ]
        [ searchForm model
        , videoListView model
        ]


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


glyphSearchIcon : Html msg
glyphSearchIcon =
    span [ class "fa fa-search", attribute "aria-hidden" "true" ] []


glyphSearchSpan : Html msg
glyphSearchSpan =
    span
        [ class "input-group-addon border-0 bg-transparent position-absolute"
        , style
            [ ( "left", "3px" )
            , ( "top", "4px" )
            , ( "z-index", "999" )
            ]
        ]
        [ glyphSearchIcon ]


clearButton : Model -> Html Msg
clearButton model =
    if not (String.isEmpty model.query) then
        button
            [ type_ "button"
            , class "close position-absolute"
            , style [ ( "right", "0" ), ( "top", "10px" ), ( "z-index", "999" ) ]
            , onClick ClearInput
            , attribute "aria-label" "Close"
            ]
            [ span [ attribute "aria-hidden" "true" ] [ text "×" ] ]
    else
        text ""


searchForm : Model -> Html Msg
searchForm model =
    let
        placeholder_text =
            if model.focus then
                "제목 혹은 발표자 검색"
            else
                "목록 보기"

        inputBox =
            input
                [ type_ "text"
                , class "form-control pl-5 input-search"
                , onInput InputQuery
                , onKeyDown OnKeyDown
                , onFocus FocusQuery
                , value model.query
                , placeholder placeholder_text
                ]
                []
    in
        div [ class "input-group input-group-lg mb-3" ]
            [ glyphSearchSpan
            , inputBox
            , clearButton model
            ]


videoListView : Model -> Html Msg
videoListView model =
    model.videoList
        |> filterVideoList model.query
        |> List.sortWith compareId
        |> List.map (videoSingleRowView model)
        |> div [ class "list-group" ]


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
                "list-group-item list-group-item-action text-white active"
            else
                "list-group-item list-group-item-action"

        hide =
            (not isActive) && (not model.focus)
    in
        case hide of
            True ->
                text ""

            False ->
                Html.a [ class aClass, onClick (ClickVideo video) ]
                    [ div [ class "font-weight-bold" ] [ text video.title ]
                    , div [ class "text-muted" ] [ text video.id ]
                    , div [ class "font-weight-light" ] [ text <| "발표자: " ++ video.speaker ]
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
                        div
                            [ class "col-md-8" ]
                            [ div [ class "embed-responsive embed-responsive-16by9" ]
                                [ iframe
                                    [ class "iframe-video embed-responsive-item"
                                    , attribute "allowfullscreen" ""
                                    , src (getEmbedUrl key)
                                    ]
                                    []
                                ]
                            ]
