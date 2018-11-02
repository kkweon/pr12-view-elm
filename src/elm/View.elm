module View exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Model exposing (Model)
import Update exposing (Msg(..))
import View.ListVideo exposing (listView)
import View.VideoScreen exposing (videoScreen)



-- View


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ div [ class "row mt-3" ]
            [ listView model
            , videoScreen model
            ]
        ]
