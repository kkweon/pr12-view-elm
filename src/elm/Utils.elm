module Utils exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (on, keyCode)
import Json.Decode as Json
import Regex exposing (find, HowMany, regex, Match)


-- | Get Key from youtube URL
getKey : String -> Maybe String
getKey url =
    let
        listMatched : List Regex.Match
        listMatched =
            find Regex.All (regex "v=([-A-z0-9]+)") url
    in
        listMatched
            |> List.head
            |> Maybe.withDefault (Regex.Match "" [] -1 -1)
            |> (.submatches)
            |> List.head
            |> Maybe.withDefault Nothing


-- | Generate an embeded URL
getEmbedUrl : String -> String
getEmbedUrl url =
    "https://www.youtube.com/embed/" ++ url


onKeyDown : (Int -> msg) -> Html.Styled.Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
