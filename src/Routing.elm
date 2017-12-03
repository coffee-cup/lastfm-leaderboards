module Routing exposing (..)

import Navigation exposing (Location)
import Route exposing (..)


type Sitemap
    = HomeRoute
    | AboutRoute
    | LeaderboardRoute String
    | NotFoundRoute


homeR : Route.Route Sitemap
homeR =
    HomeRoute := static ""


aboutR : Route.Route Sitemap
aboutR =
    AboutRoute := static "about"


leaderboardR : Route.Route Sitemap
leaderboardR =
    LeaderboardRoute := static "lb" </> string


sitemap : Route.Router Sitemap
sitemap =
    router [ homeR, aboutR ]


removeTrailingSlash : String -> String
removeTrailingSlash s =
    if (String.endsWith "/" s) && (String.length s > 1) then
        String.dropRight 1 s
    else
        s


match : String -> Sitemap
match s =
    s
        |> removeTrailingSlash
        |> Route.match sitemap
        |> Maybe.withDefault NotFoundRoute


toString : Sitemap -> String
toString r =
    case r of
        HomeRoute ->
            reverse homeR []

        AboutRoute ->
            reverse aboutR []

        LeaderboardRoute usersString ->
            reverse leaderboardR [ usersString ]

        NotFoundRoute ->
            "/404"


mainTitle : String
mainTitle =
    "Title ✌️"


pageTitle : Sitemap -> String
pageTitle r =
    case r of
        HomeRoute ->
            mainTitle

        AboutRoute ->
            mainTitle ++ " - About"

        LeaderboardRoute usersString ->
            usersString

        NotFoundRoute ->
            "Not Found"


parseLocation : Location -> Sitemap
parseLocation location =
    match location.pathname


navigateTo : Sitemap -> Cmd msg
navigateTo =
    toString >> Navigation.newUrl
