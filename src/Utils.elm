module Utils exposing (..)

import Routing exposing (Sitemap(..))


routeToUsersString : Sitemap -> String
routeToUsersString sitemap =
    case sitemap of
        LeaderboardRoute usersString ->
            usersString
                |> String.split "+"
                |> String.join ", "

        _ ->
            ""


classify : String -> String
classify s =
    s
        |> String.toLower
        |> String.split " "
        |> String.join "-"


boolToInt : Bool -> Int
boolToInt b =
    case b of
        True ->
            1

        False ->
            0


sortByFlip : (a -> comparable) -> List a -> List a
sortByFlip f l =
    List.sortWith (\a b -> flippedComparison (f a) (f b)) l


flippedComparison : comparable -> comparable -> Order
flippedComparison a b =
    case compare a b of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


weekAgo : Int -> Int
weekAgo time =
    let
        delta =
            24 * 60 * 60 * 7
    in
        time - delta
