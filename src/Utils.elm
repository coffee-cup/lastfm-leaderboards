module Utils exposing (..)

import Routing exposing (Sitemap(..))


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


weekAgo : Int -> Int
weekAgo time =
    let
        delta =
            24 * 60 * 60 * 7
    in
        time - delta


routeToUsersString : Sitemap -> String
routeToUsersString sitemap =
    case sitemap of
        LeaderboardRoute usersString ->
            usersString
                |> String.split "+"
                |> String.join ", "

        _ ->
            ""


usersCommaStringToList : String -> List String
usersCommaStringToList s =
    s
        |> String.words
        |> String.join ""
        |> String.split ","


usersCommaStringToPlusString : String -> String
usersCommaStringToPlusString s =
    s |> usersCommaStringToList |> String.join "+"


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


replaceItemInList : (a -> comparable) -> a -> List a -> List a
replaceItemInList f newItem l =
    l
        |> List.map
            (\i ->
                if f i == f newItem then
                    newItem
                else
                    i
            )
