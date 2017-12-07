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


leaderboardList : List ( Title, User -> ( Int, String ) )
leaderboardList =
    [ ( "Top Scrobbles", \u -> ( u.playCount, (toString u.playCount) ++ " scrobbles" ) )
    , ( "Top Scrobbles", \u -> ( u.playCount, (toString u.playCount) ++ " scrobbles" ) )
    ]


view : Model -> Html Msg
view model =
    div [ class "leaderboards" ]
        [ introView
        , div [ class "flex pv2" ]
            (List.map (\( t, f ) -> leaderboardView f t model.users) leaderboardList)
        ]


introView : Html Msg
introView =
    div [ class "intro" ]
        [ p [ class "measure text-lightgray" ]
            [ text "Based on last 7 days of listening" ]
        ]


leaderboardView : (User -> ( comparable, String )) -> Title -> List User -> Html Msg
leaderboardView rankFn title users =
    let
        compareFn =
            rankFn >> Tuple.first

        userView_ =
            userView <| rankFn >> Tuple.second

        sortedUsers =
            sortByFlip compareFn users
    in
        div [ class "leaderboard pr2" ]
            [ h3 [ class "f3 mt0" ] [ text title ]
            , div []
                (List.map userView_ sortedUsers)
            ]


userView : (User -> String) -> User -> Html Msg
userView displayFn user =
    let
        userUrl =
            user.url ++ "/library?date_preset=LAST_7_DAYS"

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
