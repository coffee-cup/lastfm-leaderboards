module Api exposing (getUserInfo, getScrobbleCount)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)
import Messages exposing (Msg(..))
import Types.User exposing (User)


type Route
    = UserInfo String
    | RecentTracks User


type alias ApiKey =
    String



-- Routes


getUserInfo : ApiKey -> String -> Cmd Msg
getUserInfo apiKey name =
    Http.get (routeToString apiKey (UserInfo name)) decodeUserInfo
        |> Http.send OnFetchUser


getScrobbleCount : ApiKey -> User -> Cmd Msg
getScrobbleCount apiKey user =
    Http.get (routeToString apiKey (RecentTracks user)) decodeRecentTracks
        |> Http.send (OnFetchRecentTracks user)


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

        RecentTracks user ->
            let
                queryParams =
                    queryParamBuilder
                        [ ( "method", "user.getRecentTracks" )
                        , ( "format", "json" )
                        , ( "api_key", apiKey )
                        , ( "limit", "200" )
                        , ( "page", "1" )
                        , ( "user", user.name )
                        , ( "from", "1509578304" )
                        ]
            in
                apiUrl ++ queryParams



-- Decoders


decodeUserInfo : Decoder User
decodeUserInfo =
    at [ "user" ] <|
        succeed User
            |: (at [ "image" ] <| index 2 <| field "#text" string)
            |: (field "name" string)
            |: (succeed Nothing)


decodeRecentTracks : Decoder Int
decodeRecentTracks =
    at [ "recenttracks", "@attr" ] <|
        (field "total" number)


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
