module Utils exposing (getEmbedUrl, getKey, onKeyDown)

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (keyCode, on)
import Json.Decode as Json
import Regex exposing (Match, find)


{-| Get Key from youtube URL
-}
getKey : String -> Maybe String
getKey url =
    let
        youtubeIdRegex : Regex.Regex
        youtubeIdRegex =
            Maybe.withDefault Regex.never <| Regex.fromString "v=([-\\w]+)|youtu.be/([-\\w]+)"

        listMatched : List Regex.Match
        listMatched =
            find youtubeIdRegex url

        regexMatch : Regex.Match
        regexMatch =
            listMatched
                |> List.head
                |> Maybe.withDefault { match = "", submatches = [], index = -1, number = -1 }
    in
    case regexMatch |> .submatches of
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
