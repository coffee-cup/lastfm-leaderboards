module Models exposing (..)

import Routing exposing (Sitemap(..))
import Flags exposing (Flags)
import Types.User exposing (User)


type alias Model =
    { route : Sitemap
    , flags : Flags
    , usersString : String
    , users : List User
    , error : String
    }


initialModel : Flags -> Sitemap -> Model
initialModel flags sitemap =
    { route = sitemap
    , flags = flags
    , usersString = routeToUsersString sitemap
    , users = []
    , error = ""
    }


routeToUsersString : Sitemap -> String
routeToUsersString sitemap =
    case sitemap of
        LeaderboardRoute usersString ->
            usersString
                |> String.split "+"
                |> String.join ", "

        _ ->
            ""
