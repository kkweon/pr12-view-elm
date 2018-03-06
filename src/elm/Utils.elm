module Utils exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (on, keyCode)
import Json.Decode as Json
import Regex exposing (find, HowMany, regex, Match)


{-| Get Key from youtube URL
-}
getKey : String -> Maybe String
getKey url =
    let
        listMatched : List Regex.Match
        listMatched =
            find Regex.All (regex "v=([-\\w]+)|youtu.be/([-\\w]+)") url

        regexMatch : Regex.Match
        regexMatch =
            listMatched
                |> List.head
                |> Maybe.withDefault ({ match = "", submatches = [], index = -1, number = -1 })
    in
        case regexMatch |> (.submatches) of
            _ :: (Just x) :: _ ->
                Just x

            (Just x) :: _ ->
                Just x

            _ ->
                Nothing


{-| Generate an embeded URL
-}
getEmbedUrl : String -> String
getEmbedUrl url =
    "https://www.youtube.com/embed/" ++ url


onKeyDown : (Int -> msg) -> Html.Styled.Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
