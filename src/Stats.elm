module Stats
    exposing
        ( uniqueArtists
        , uniqueAlbums
        , uniqueTracks
        , sameArtist
        , sameAlbum
        , sameTrack
        )

import Dict
import Types.User exposing (User)
import Utils exposing (sortByFlip)


uniqueArtists : User -> Int
uniqueArtists user =
    countUnique .artist user.tracks


uniqueAlbums : User -> Int
uniqueAlbums user =
    countUnique .album user.tracks


uniqueTracks : User -> Int
uniqueTracks user =
    countUnique .name user.tracks


sameArtist : User -> ( String, Int )
sameArtist user =
    topUnique .artist user.tracks


sameAlbum : User -> ( String, Int )
sameAlbum user =
    topUnique .album user.tracks


sameTrack : User -> ( String, Int )
sameTrack user =
    topUnique .name user.tracks


topUnique : (a -> String) -> List a -> ( String, Int )
topUnique f l =
    let
        unique =
            Dict.toList <| getUnique f l

        sortedUnique =
            sortByFlip Tuple.second unique
    in
        Maybe.withDefault ( "", 0 ) <| List.head sortedUnique


countUnique : (a -> String) -> List a -> Int
countUnique f l =
    Dict.size <| getUnique f l


getUnique : (a -> String) -> List a -> Dict.Dict String Int
getUnique f l =
    let
        updateFn mv =
            case mv of
                Nothing ->
                    Just 1

                Just v ->
                    Just (v + 1)

        unique =
            List.foldr
                (\i acc ->
                    case f i of
                        "" ->
                            acc

                        _ ->
                            Dict.update (f i) updateFn acc
                )
                Dict.empty
                l
    in
        unique
