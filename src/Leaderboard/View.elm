module Leaderboard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList, src)
import Html.Events exposing (onClick)
import Types.User exposing (User)
import Messages exposing (Msg(..))
import Models exposing (Model)
import ViewUtils exposing (..)


view : Model -> Html Msg
view model =
    div [ class "leaderboards" ]
        [ h1 [ class "f-subheadline-ns f1 measure mv4 pointer", onClick ShowHome ]
            [ text "LastFm"
            , br [] []
            , text "Leaderboards"
            ]
        , errorView model
        , introView
        , div [ class "users pv2" ]
            (List.map userView model.users)
        ]


introView : Html Msg
introView =
    div [ class "intro" ]
        [ p [ class "measure" ]
            [ text "# of scrobbles in last 7 days." ]
        ]


userView : User -> Html Msg
userView user =
    div [ class ("user pv3 flex ac " ++ user.name) ]
        [ userImage user
        , div []
            [ p [ class "f3 mr4 mv0" ] [ text user.name ]
            , countView user.playcount
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


countView : Maybe Int -> Html Msg
countView mcount =
    let
        scount =
            toString <| Maybe.withDefault 0 mcount
    in
        p [ class "user-scobble-count f5 flex ac mv0 text-lightgray" ]
            [ text (scount ++ " scrobbles") ]


errorView : Model -> Html Msg
errorView model =
    div [ class "error red" ]
        [ text model.error ]
