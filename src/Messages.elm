module Messages exposing (..)

import Http
import Navigation exposing (Location)
import Types.User exposing (User)


type Msg
    = OnLocationChange Location
    | ShowHome
    | ShowAbout
    | ShowLeaderboard
    | UsersStringChange String
    | OnFetchUser (Result Http.Error User)
    | OnFetchRecentTracks User (Result Http.Error Int)
