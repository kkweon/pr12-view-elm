module Utils exposing (..)

import Regex exposing (find, HowMany, regex, Match)


temp =
    "https://www.youtube.com/watch?v=auKdde7Anr8&list=PLlMkM4tgfjnJhhd4wn5aj8fVTYJwIpWkS"


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


getEmbedUrl : String -> String
getEmbedUrl url =
    "https://www.youtube.com/embed/" ++ url
