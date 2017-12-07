module Api exposing (getUserInfo, getRecentTracks)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)
import Messages exposing (Msg(..))
import Types.User exposing (User, userFromInfo, updateUserWithTracks)
import Types.Track exposing (Track)


type Route
    = UserInfo String
    | RecentTracks User Int Int


type alias ApiKey =
    String



-- Routes


getUserInfo : ApiKey -> String -> Cmd Msg
getUserInfo apiKey name =
    Http.get (routeToString apiKey (UserInfo name)) decodeUserInfo
        |> Http.send OnFetchUser


getRecentTracks : ApiKey -> User -> Int -> Int -> Cmd Msg
getRecentTracks apiKey user since page =
    Http.get (routeToString apiKey (RecentTracks user since page)) (decodeRecentTracks user)
        |> Http.send OnFetchRecentTracks


apiUrl : String
apiUrl =
    "https://ws.audioscrobbler.com/2.0/?"


queryParamBuilder : List ( String, String ) -> String
queryParamBuilder params =
    params
        |> List.foldl (\( l, r ) acc -> acc ++ l ++ "=" ++ r ++ "&") ""


routeToString : ApiKey -> Route -> String
routeToString apiKey route =
    case route of
        UserInfo name ->
            let
                queryParams =
                    queryParamBuilder
                        [ ( "method", "user.getInfo" )
                        , ( "format", "json" )
                        , ( "api_key", apiKey )
                        , ( "user", name )
                        ]
            in
                apiUrl ++ queryParams

        RecentTracks user since page ->
            let
                queryParams =
                    queryParamBuilder
                        [ ( "method", "user.getRecentTracks" )
                        , ( "format", "json" )
                        , ( "api_key", apiKey )
                        , ( "limit", "200" )
                        , ( "page", toString page )
                        , ( "user", user.name )
                        , ( "from", toString since )
                        ]
            in
                apiUrl ++ queryParams



-- Decoders


decodeUserInfo : Decoder User
decodeUserInfo =
    at [ "user" ] <|
        succeed userFromInfo
            |: (at [ "image" ] <| index 2 <| field "#text" string)
            |: (field "name" string)
            |: (field "url" string)


decodeRecentTracks : User -> Decoder User
decodeRecentTracks user =
    let
        updateUserWithTracks_ =
            updateUserWithTracks user
    in
        succeed updateUserWithTracks_
            |: (at [ "recenttracks", "@attr" ] <| (field "total" number))
            |: (at [ "recenttracks", "@attr" ] <| (field "page" number))
            |: (at [ "recenttracks", "@attr" ] <| (field "totalPages" number))
            |: (at [ "recenttracks", "track" ] <| (list decodeTrack))


decodeTrack : Decoder Track
decodeTrack =
    succeed Track
        |: (field "name" string)
        |: (at [ "artist" ] <| (field "#text" string))
        |: (at [ "album" ] <| (field "#text" string))
        |: (field "url" string)


number : Decoder Int
number =
    oneOf [ int, string |> customDecoder String.toInt ]


eitherR : (x -> b) -> (a -> b) -> Result x a -> b
eitherR fErr fOk result =
    case result of
        Err x ->
            fErr x

        Ok a ->
            fOk a


customDecoder : (a -> Result String b) -> Decoder a -> Decoder b
customDecoder fResult decoder =
    decoder |> andThen (fResult >> eitherR fail succeed)
