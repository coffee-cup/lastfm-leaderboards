module Messages exposing (..)

import Navigation exposing (Location)
import Http
import Types exposing (User)


type Msg
    = OnLocationChange Location
    | ShowHome
    | ShowAbout
    | ShowLeaderboard String
    | OnFetchUser (Result Http.Error User)
    | OnFetchRecentTracks (Result Http.Error User)
