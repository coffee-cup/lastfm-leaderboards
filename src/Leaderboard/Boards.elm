module Leaderboard.Boards
    exposing
        ( Title
        , Leaderboard
        , leaderboardList
        )

import Types.User exposing (User)


type alias Title =
    String


type alias Leaderboard =
    { id : String
    , title : String
    , urlSuffix : String
    , rankFn : User -> ( Int, String )
    }


scrobbleLeaderboard : Leaderboard
scrobbleLeaderboard =
    { id = "scobbles"
    , title = "Total Scrobbles"
    , urlSuffix = "/library?date_preset=LAST_7_DAYS"
    , rankFn = \u -> ( u.playCount, (toString u.playCount) ++ " scrobbles" )
    }


artistLeaderboard : Leaderboard
artistLeaderboard =
    { id = "artists"
    , title = "Unique Artists"
    , urlSuffix = "/library/artists?date_preset=LAST_7_DAYS"
    , rankFn = \u -> ( u.artistCount, (toString u.artistCount) ++ " artists" )
    }


albumLeaderboard : Leaderboard
albumLeaderboard =
    { id = "albums"
    , title = "Unique Albums"
    , urlSuffix = "/library/albums?date_preset=LAST_7_DAYS"
    , rankFn = \u -> ( u.albumCount, (toString u.albumCount) ++ " albums" )
    }


trackLeaderboard : Leaderboard
trackLeaderboard =
    { id = "artists"
    , title = "Unique Tracks"
    , urlSuffix = "/library/tracks?date_preset=LAST_7_DAYS"
    , rankFn = \u -> ( u.trackCount, (toString u.trackCount) ++ " tracks" )
    }


sameArtistLeaderboard : Leaderboard
sameArtistLeaderboard =
    { id = "same-artist"
    , title = "Same Artist"
    , urlSuffix = "/library/artists?date_preset=LAST_7_DAYS"
    , rankFn = sameRankFn .sameArtist
    }


sameAlbumLeaderboard : Leaderboard
sameAlbumLeaderboard =
    { id = "same-album"
    , title = "Same Album"
    , urlSuffix = "/library/albums?date_preset=LAST_7_DAYS"
    , rankFn = sameRankFn .sameAlbum
    }


sameTrackLeaderboard : Leaderboard
sameTrackLeaderboard =
    { id = "same-track"
    , title = "Same Track"
    , urlSuffix = "/library/tracks?date_preset=LAST_7_DAYS"
    , rankFn = sameRankFn .sameTrack
    }


leaderboardList : List Leaderboard
leaderboardList =
    [ scrobbleLeaderboard
    , artistLeaderboard
    , albumLeaderboard
    , trackLeaderboard
    , sameArtistLeaderboard
    , sameAlbumLeaderboard
    , sameTrackLeaderboard
    ]


sameRankFn : (User -> ( String, Int )) -> User -> ( Int, String )
sameRankFn f =
    \u ->
        ( Tuple.second <| f u
        , (Tuple.first <| f u)
            ++ " "
            ++ (toString <| Tuple.second <| f u)
            ++ " times"
        )
