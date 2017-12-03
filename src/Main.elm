module Main exposing (..)

import Navigation exposing (Location)
import Flags exposing (Flags)
import Models exposing (Model, initialModel)
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Commands exposing (getLeaderboardCommand)
import View exposing (view)
import Update exposing (update, changeMetadata, pageView)
import Routing


-- Init


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location

        leaderboardCommand =
            getLeaderboardCommand currentRoute flags

        metadataCommand =
            changeMetadata (Routing.pageTitle currentRoute)

        commands =
            [ leaderboardCommand, metadataCommand ]
    in
        ( initialModel flags currentRoute
        , Cmd.batch commands
        )



-- Main


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
