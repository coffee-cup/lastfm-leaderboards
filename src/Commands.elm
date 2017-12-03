module Commands exposing (..)

import Flags exposing (Flags)
import Messages exposing (Msg(..))
import Routing exposing (Sitemap(..))
import Api exposing (..)


getLeaderboardCommand : Sitemap -> Flags -> Cmd Msg
getLeaderboardCommand route flags =
    case route of
        LeaderboardRoute usersString ->
            let
                usersStringList =
                    usersString |> String.split "+"

                cmdBuilder =
                    getUserInfo flags.apiKey

                commands =
                    List.map cmdBuilder usersStringList
            in
                Cmd.batch commands

        _ ->
            Cmd.none
