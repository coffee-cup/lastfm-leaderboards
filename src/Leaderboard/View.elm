module Leaderboard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList, src, target)
import Types.User exposing (User)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Utils exposing (..)


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


leaderboardList : List Leaderboard
leaderboardList =
    [ scrobbleLeaderboard, artistLeaderboard, albumLeaderboard, trackLeaderboard ]


view : Model -> Html Msg
view model =
    div [ class "leaderboards" ]
        [ introView
        , div [ class "flex-w pv2" ]
            (List.map (leaderboardView model.users) leaderboardList)
        ]


introView : Html Msg
introView =
    div [ class "intro" ]
        [ p [ class "measure text-lightgray mb0" ]
            [ text "Based on last 7 days of listening" ]
        ]


leaderboardView : List User -> Leaderboard -> Html Msg
leaderboardView users leaderboard =
    let
        compareFn =
            leaderboard.rankFn >> Tuple.first

        displayFn =
            leaderboard.rankFn >> Tuple.second

        userView_ =
            userView displayFn leaderboard.urlSuffix

        sortedUsers : List User
        sortedUsers =
            sortByFlip compareFn users
    in
        div [ class <| "leaderboard pr2 " ++ leaderboard.id ]
            [ h2 [ class "f3 mb1" ] [ text leaderboard.title ]
            , div []
                (List.map userView_ sortedUsers)
            ]


userView : (User -> String) -> String -> User -> Html Msg
userView displayFn suffix user =
    let
        userUrl =
            user.url ++ suffix

        displayText =
            displayFn user
    in
        a [ href userUrl, class "none", target "_blank" ]
            [ div [ class ("user pv3 flex ac " ++ user.name) ]
                [ userImage user
                , div [ class "mr5" ]
                    [ p [ class "f3 mv0" ] [ text user.name ]
                    , p [ class "f5 flex ac mv0 text-lightgray" ]
                        [ text displayText ]
                    ]
                ]
            ]


userImage : User -> Html Msg
userImage user =
    let
        imageUrl =
            case user.image of
                "" ->
                    "https://lastfm-img2.akamaized.net/i/u/avatar170s/818148bf682d429dc215c1705eb27b98"

                _ ->
                    user.image
    in
        img [ src imageUrl, class "user-image mr4" ] []


countView : Int -> Html Msg
countView pcount =
    p [ class "user-scobble-count f5 flex ac mv0 text-lightgray" ]
        [ text ((toString pcount) ++ " scrobbles") ]


errorView : Model -> Html Msg
errorView model =
    div [ class "error red" ]
        [ text model.error ]
