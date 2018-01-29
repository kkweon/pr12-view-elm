module View.ListVideo exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Update exposing (Msg(..))
import Database exposing (Video)
import View.SearchInput exposing (searchForm)


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


compareId : Video -> Video -> Order
compareId a b =
    case compare a.id b.id of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


videoListView : Model -> Html Msg
videoListView model =
    model.videoList
        |> filterVideoList model.query
        |> List.sortWith compareId
        |> List.map (videoSingleRowView model)
        |> div [ class "list-group" ]


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
                a
                    [ class aClass
                    , css [ cursor pointer ]
                    , onClick (ClickVideo video)
                    ]
                    [ div [ class "font-weight-bold" ] [ text video.title ]
                    , div [ class "font-weight-italic" ] [ text video.id ]
                    , div [ class "font-weight-light" ] [ text <| "발표자: " ++ video.speaker ]
                    ]


listView : Model -> Html Msg
listView model =
    div [ class "col-md-3 mb-3" ]
        [ searchForm model
        , videoListView model
        ]
