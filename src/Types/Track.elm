module Types.Track exposing (..)


type alias Track =
    { name : String
    , artist : String
    , album : String
    , url : String
    }


emptyTrack : Track
emptyTrack =
    { name = ""
    , artist = ""
    , album = ""
    , url = ""
    }
