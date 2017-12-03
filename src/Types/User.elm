module Types.User exposing (..)


type alias User =
    { image : String
    , name : String
    , url : String
    , playcount : Maybe Int
    }
