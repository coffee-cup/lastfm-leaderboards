module Types.User exposing (..)


type alias User =
    { image : String
    , name : String
    , playcount : Maybe Int
    }
