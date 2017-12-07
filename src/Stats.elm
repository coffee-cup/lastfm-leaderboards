module Stats exposing (uniqueArtists, uniqueAlbums, uniqueTracks)

import Dict
import Types.User exposing (User)


uniqueArtists : User -> Int
uniqueArtists user =
    countUnique .artist user.tracks


uniqueAlbums : User -> Int
uniqueAlbums user =
    countUnique .album user.tracks


uniqueTracks : User -> Int
uniqueTracks user =
    countUnique .name user.tracks


countUnique : (a -> comparable) -> List a -> Int
countUnique f l =
    let
        updateFn mv =
            case mv of
                Nothing ->
                    Just 1

                Just v ->
                    Just (v + 1)

        unique =
            List.foldr (\i acc -> Dict.update (f i) updateFn acc) Dict.empty l
    in
        Dict.size unique
