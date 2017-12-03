module Utils exposing (..)


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
