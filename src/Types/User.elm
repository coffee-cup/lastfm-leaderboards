module Types.User exposing (..)

import Types.Track exposing (..)


type alias User =
    { image : String
    , name : String
    , url : String
    , pages : Int
    , playcount : Int
    , tracks : List Track
    }


userFromInfo : String -> String -> String -> User
userFromInfo image name url =
    { image = image
    , name = name
    , url = url
    , pages = 0
    , playcount = 0
    , tracks = []
    }


updateUserWithTracks : User -> Int -> List Track -> User
updateUserWithTracks user p ts =
    { user | playcount = p, tracks = ts }
