module View.ListVideo exposing (compareId, filterVideoList, isRelatedVideo, listView, scrollOnDesktop, videoListView, videoSingleRowView)

import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Database exposing (Video)
import Fuzzy exposing (Result, match)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Update exposing (Msg(..))
import View.SearchInput exposing (searchForm)


{-| If Video contains query in the title or speaker or id, return True
-}
isRelatedVideo : ( Video, Result ) -> Bool
isRelatedVideo ( video, result ) =
    result.score < 100



-- { id : String
-- , title : String
-- , speaker : String
-- , link : String
-- }


getFuzzyScore : String -> Video -> ( Video, Result )
getFuzzyScore needle video =
    let
        targetText =
            [ video.id, video.title, video.speaker ]
                |> String.join " "
                |> String.toLower

        result =
            match [ Fuzzy.movePenalty 0, Fuzzy.addPenalty 0 ] [] (String.toLower needle) targetText
    in
    ( video, result )


filterVideoList : String -> List Video -> List ( Video, Result )
filterVideoList query videoList =
    case String.isEmpty query of
        True ->
            videoList |> List.map (\v -> ( v, { score = 0, matches = [] } ))

        False ->
            videoList
                |> List.map (getFuzzyScore query)
                |> List.filter isRelatedVideo


compareId : ( Video, Result ) -> ( Video, Result ) -> Order
compareId ( v1, r1 ) ( v2, r2 ) =
    case compare r1.score r2.score of
        EQ ->
            compare v1.id v2.id

        x ->
            x


scrollOnDesktop : Attribute msg
scrollOnDesktop =
    css
        [ withMedia [ only screen [ Media.minWidth (px 900) ] ]
            [ overflowY auto, maxHeight (vh 90) ]
        ]


videoListView : Model -> Html Msg
videoListView model =
    model.videoList
        |> filterVideoList model.query
        |> List.sortWith compareId
        |> List.map (videoSingleRowView model)
        |> div [ class "list-group", scrollOnDesktop ]


videoSingleRowView : Model -> ( Video, Result ) -> Html Msg
videoSingleRowView model ( video, result ) =
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
            not isActive && not model.focus
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
