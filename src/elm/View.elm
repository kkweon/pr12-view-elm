module View exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Update exposing (Msg)
import Model exposing (Model)
import View.ListVideo exposing (listView)
import View.VideoScreen exposing (videoScreen)
import Update exposing (Msg(..))


-- View


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ div [ class "row mt-3" ]
            [ listView model
            , videoScreen model
            ]
        ]
