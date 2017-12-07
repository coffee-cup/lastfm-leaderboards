module Leaderboard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList, src, target)
import Types.User exposing (User)
import Types.Track exposing (Track, emptyTrack)
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


scrobbleLeaderboard =
    { id = "scobbles"
    , title = "Top Scrobbles"
    , urlSuffix = "/library?date_preset=LAST_7_DAYS"
    , rankFn = \u -> ( u.playCount, (toString u.playCount) ++ " scrobbles" )
    }


leaderboardList : List Leaderboard
leaderboardList =
    [ scrobbleLeaderboard ]


view : Model -> Html Msg
view model =
    div [ class "leaderboards" ]
        [ introView
        , div [ class "flex pv2" ]
            (List.map (leaderboardView model.users) leaderboardList)
        ]


introView : Html Msg
introView =
    div [ class "intro" ]
        [ p [ class "measure text-lightgray" ]
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
        div [ class "leaderboard pr2" ]
            [ h3 [ class "f3 mt0" ] [ text leaderboard.title ]
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
                , div []
                    [ p [ class "f3 mr4 mv0" ] [ text user.name ]
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
