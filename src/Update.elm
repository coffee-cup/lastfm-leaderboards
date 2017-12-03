port module Update exposing (..)

import Api exposing (getUserInfo, getScrobbleCount)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Utils exposing (..)


port scrollToTop : Bool -> Cmd msg


port pageView : String -> Cmd msg


port changeMetadata : String -> Cmd msg


changePage : Sitemap -> Cmd msg
changePage page =
    Cmd.batch
        [ navigateTo page
        , scrollToTop True
        , changeMetadata (Routing.pageTitle page)
        , pageView (Routing.toString page)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        ShowHome ->
            ( model, changePage HomeRoute )

        ShowAbout ->
            ( model, changePage AboutRoute )

        UsersStringChange usersString ->
            ( { model | usersString = usersString }, Cmd.none )

        ShowLeaderboard ->
            let
                usersList =
                    model.usersString
                        |> String.words
                        |> String.join ""
                        |> String.split ","

                plusString =
                    usersList |> String.join "+"

                usersCommands =
                    List.map (getUserInfo model.flags.apiKey) usersList

                commands =
                    changePage (LeaderboardRoute plusString) :: usersCommands
            in
                ( { model | users = [] }, Cmd.batch commands )

        OnFetchUser (Ok user) ->
            ( { model | users = user :: model.users }, getScrobbleCount model.flags.apiKey user )

        OnFetchUser (Err _) ->
            ( { model | error = "Error fetching user" }, Cmd.none )

        OnFetchRecentTracks user (Ok playcount) ->
            let
                newUsers =
                    model.users
                        |> List.map
                            (\u ->
                                if u.name == user.name then
                                    { u | playcount = Just playcount }
                                else
                                    u
                            )
                        |> sortByFlip (\u -> Maybe.withDefault 0 u.playcount)
            in
                ( { model | users = newUsers }, Cmd.none )

        OnFetchRecentTracks _ _ ->
            ( { model | error = "Error fetching recent tracks" }, Cmd.none )
