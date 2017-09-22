module Model exposing (..)

type alias Model =
    { query : String
    , videoList : List Video
    , currentVideo : Maybe Video
    }


initModel : Model
initModel =
    { query = ""
    , videoList = videoList
    , currentVideo = Nothing
    }


init : ( Model, Cmd Msg )
init =
    initModel ! []
