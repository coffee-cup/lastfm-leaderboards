module Commands exposing (..)

import Flags exposing (Flags)
import Messages exposing (Msg(..))
import Routing exposing (Sitemap(..))


getLeaderboardCommand : Sitemap -> Flags -> Cmd Msg
getLeaderboardCommand route flags =
    case route of
        LeaderboardRoute usersString ->
            let
                usersStringList =
                    String.split "+" usersString
            in
                Cmd.none

        _ ->
            Cmd.none
