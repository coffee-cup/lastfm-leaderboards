port module Update exposing (..)

import Api exposing (getUserInfo, getScrobbleCount)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Utils exposing (..)
import Types.User exposing (User)


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

                newUsersString =
                    routeToUsersString newRoute

                newModel =
                    { model | usersString = newUsersString, users = [] }

                usersCommands =
                    getUserInfoCommands newModel
            in
                ( { newModel | route = newRoute }, usersCommands )

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
            in
                ( { model | users = [] }, changePage (LeaderboardRoute plusString) )

        OnFetchUser (Ok user) ->
            ( { model | users = user :: model.users }, getUserPlayCount model user )

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


getUserPlayCount : Model -> User -> Cmd Msg
getUserPlayCount model user =
    let
        aWeekAgo =
            weekAgo model.flags.now
    in
        getScrobbleCount model.flags.apiKey user aWeekAgo


getUserInfoCommands : Model -> Cmd Msg
getUserInfoCommands model =
    let
        usersList =
            model.usersString
                |> String.words
                |> String.join ""
                |> String.split ","

        usersCommands =
            List.map (getUserInfo model.flags.apiKey) usersList
    in
        Cmd.batch usersCommands
