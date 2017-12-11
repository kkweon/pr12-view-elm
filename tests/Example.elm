module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Utils


suite : Test
suite =
    describe "The Util module"
        [ describe "getKey"
            [ test "Returns a correct key" <|
                \_ ->
                    let
                        url =
                            "https://www.youtube.com/watch?v=keyvalue"
                    in
                        Expect.equal (Just "keyvalue") (Utils.getKey url)
            , test "Returns a correct key regardless of parameters" <|
                \_ ->
                    let
                        url =
                            "https://www.youtube.com/watch?v=keyvalue&whatever=param"
                    in
                        Expect.equal (Just "keyvalue") (Utils.getKey url)
            ]
        , describe "getEmbedUrl"
            [ test "Returns an emebeded youtube url" <|
                \_ ->
                    let
                        url =
                            "https://www.youtube.com/watch?v=keyvalue&random=value"

                        key =
                            Utils.getKey url
                                |> Maybe.withDefault ""

                        embedUrl =
                            Utils.getEmbedUrl key
                    in
                        Expect.equal ("https://www.youtube.com/embed/keyvalue") embedUrl
            ]
        ]
