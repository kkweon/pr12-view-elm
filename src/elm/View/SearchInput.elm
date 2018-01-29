module View.SearchInput exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes
    exposing
        ( class
        , css
        , placeholder
        , src
        , value
        , style
        , type_
        , attribute
        )
import Html.Styled.Events exposing (onInput, onClick, onFocus, on, keyCode)
import Model exposing (Model)
import Update exposing (Msg(..))
import View.GlyphIcons exposing (spanBuilder, glyphSearchIcon, glyphMenuIcon, clearButton)
import Utils exposing (onKeyDown)


searchForm : Model -> Html Msg
searchForm model =
    let
        placeholder_text =
            if model.focus then
                "제목 혹은 발표자 검색"
            else
                "목록 보기"

        inputBox =
            input
                [ type_ "text"
                , class "form-control pl-5 search-box"
                , onInput InputQuery
                , onKeyDown OnKeyDown
                , onFocus FocusQuery
                , value model.query
                , placeholder placeholder_text
                ]
                []

        spanIcon =
            if model.focus then
                spanBuilder glyphSearchIcon
            else
                spanBuilder glyphMenuIcon
    in
        div [ class "input-group input-group-lg mb-3", css [ (position relative) ] ]
            [ spanIcon
            , inputBox
            , clearButton model
            ]
