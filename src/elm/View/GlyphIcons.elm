module View.GlyphIcons exposing (clearButton, faBuilder, glyphMenuIcon, glyphSearchIcon, spanBuilder)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes
    exposing
        ( attribute
        , class
        , css
        , placeholder
        , src
        , style
        , type_
        , value
        )
import Html.Styled.Events exposing (keyCode, on, onClick, onFocus, onInput)
import Model exposing (Model)
import Update exposing (Msg(..))


faBuilder : String -> Html msg
faBuilder name =
    span [ class ("fa " ++ name), attribute "aria-hidden" "true" ] []


glyphSearchIcon : Html msg
glyphSearchIcon =
    faBuilder "fa-search"


glyphMenuIcon : Html msg
glyphMenuIcon =
    faBuilder "fa-bars"


spanBuilder : Html Msg -> Html Msg
spanBuilder icon =
    span
        [ class "input-group-addon border-0 bg-transparent p-0"
        , css
            [ left (Css.rem 1)
            , top (pct 50)
            , zIndex (int 999)
            , position absolute
            , transform (translateY (pct -50))
            ]
        , onClick FocusQuery
        ]
        [ icon ]


clearButton : Model -> Html Msg
clearButton model =
    if not (String.isEmpty model.query) then
        button
            [ type_ "button"
            , class "close position-absolute p-0"
            , css
                [ right (pct 2)
                , top (pct 50)
                , transform (translateY (pct -50))
                , zIndex (int 999)
                ]
            , onClick ClearInput
            , attribute "aria-label" "Close"
            ]
            [ span [ attribute "aria-hidden" "true" ] [ text "×" ] ]

    else
        text ""
