module Model exposing (Model, init, initModel)

import Database exposing (Video, videoList)


type alias Model =
    { query : String
    , videoList : List Video
    , currentVideo : Maybe Video
    , focus : Bool
    }


initModel : Model
initModel =
    Model "" videoList Nothing True


init : ( Model, Cmd msg )
init =
    ( initModel, Cmd.none )
