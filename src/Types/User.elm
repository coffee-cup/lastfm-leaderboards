module Types.User exposing (..)

import Types.Track exposing (..)


type alias User =
    { image : String
    , name : String
    , url : String
    , playCount : Int
    , page : Int
    , totalPages : Int
    , tracks : List Track
    }


userFromInfo : String -> String -> String -> User
userFromInfo image name url =
    { image = image
    , name = name
    , url = url
    , playCount = 0
    , page = 0
    , totalPages = 0
    , tracks = []
    }


updateUserWithTracks : User -> Int -> Int -> Int -> List Track -> User
updateUserWithTracks user playCount page totalPages tracks =
    { user
        | playCount = playCount
        , page = page
        , totalPages = totalPages
        , tracks = tracks
    }
