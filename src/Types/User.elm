module Types.User exposing (..)

import Types.Track exposing (..)


type alias User =
    { image : String
    , name : String
    , url : String
    , page : Int
    , totalPages : Int
    , tracks : List Track
    , playCount : Int
    , artistCount : Int
    , albumCount : Int
    , trackCount : Int
    }


userFromInfo : String -> String -> String -> User
userFromInfo image name url =
    { image = image
    , name = name
    , url = url
    , page = 0
    , totalPages = 0
    , tracks = []
    , playCount = 0
    , artistCount = 0
    , albumCount = 0
    , trackCount = 0
    }


updateUserWithTracks : User -> Int -> Int -> Int -> List Track -> User
updateUserWithTracks user playCount page totalPages tracks =
    { user
        | page = page
        , totalPages = totalPages
        , tracks = user.tracks ++ tracks
        , playCount = playCount
    }
