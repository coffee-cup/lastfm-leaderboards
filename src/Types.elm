module Types exposing (..)


type alias Url =
    String


type alias User =
    { name : String
    , image : Url
    , playcount : Maybe Int
    }
