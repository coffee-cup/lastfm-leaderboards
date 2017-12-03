module Api exposing (getUserInfo)

import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)
import Messages exposing (Msg(..))
import Types.User exposing (User)


type Route
    = UserInfo String
    | RecentTracks


type alias ApiKey =
    String



-- Routes


getUserInfo : ApiKey -> String -> Cmd Msg
getUserInfo apiKey name =
    Http.get (routeToString apiKey (UserInfo name)) decodeUserInfo
        |> Http.send OnFetchUser


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

        _ ->
            ""



-- Decoders


decodeUserInfo : Decoder User
decodeUserInfo =
    at [ "user" ] <|
        succeed User
            |: (at [ "image" ] <| index 2 <| field "#text" string)
            |: (field "name" string)
            |: (succeed Nothing)
