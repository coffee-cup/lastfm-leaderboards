port module Update exposing (..)

import Api exposing (getUserInfo, getScrobbleCount)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Navigation exposing (Location)
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
            locationChange location model

        ShowHome ->
            ( model, changePage HomeRoute )

        ShowAbout ->
            ( model, changePage AboutRoute )

        UsersStringChange usersString ->
            ( { model | usersString = usersString }, Cmd.none )

        ShowLeaderboard ->
            ( { model | users = [] }
            , changePage <| LeaderboardRoute <| usersCommaStringToPlusString <| model.usersString
            )

        OnFetchUser (Ok user) ->
            ( { model | users = user :: model.users }, getUserPlayCount model user )

        OnFetchUser (Err _) ->
            ( { model | error = "Error fetching user" }, Cmd.none )

        OnFetchRecentTracks (Ok newUser) ->
            fetchedTracksForUser newUser model

        OnFetchRecentTracks _ ->
            ( { model | error = "Error fetching recent tracks" }, Cmd.none )


fetchedTracksForUser : User -> Model -> ( Model, Cmd Msg )
fetchedTracksForUser newUser model =
    let
        newUsers =
            model.users
                |> replaceItemInList .name newUser
                |> sortByFlip .playCount
    in
        ( { model | users = newUsers }, Cmd.none )


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
        usersCommands =
            List.map (getUserInfo model.flags.apiKey) (usersCommaStringToList model.usersString)
    in
        Cmd.batch usersCommands


locationChange : Location -> Model -> ( Model, Cmd Msg )
locationChange location model =
    let
        newRoute =
            parseLocation location

        newUsersString =
            routeToUsersString newRoute

        newModel =
            { model
                | usersString = newUsersString
                , route = newRoute
                , users = []
            }

        usersCommands =
            getUserInfoCommands newModel
    in
        ( newModel, usersCommands )
