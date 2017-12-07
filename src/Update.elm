port module Update exposing (..)

import Api exposing (getUserInfo, getRecentTracks)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Navigation exposing (Location)
import Utils exposing (..)
import Types.User exposing (User)
import Stats exposing (uniqueArtists, uniqueAlbums, uniqueTracks)


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
            ( { model | users = user :: model.users }, getUserTracks model user 1 )

        OnFetchUser (Err _) ->
            ( { model | error = "Error fetching user" }, Cmd.none )

        OnFetchRecentTracks (Ok newUser) ->
            fetchedTracksForUser newUser model

        OnFetchRecentTracks _ ->
            ( { model | error = "Error fetching recent tracks" }, Cmd.none )


fetchedTracksForUser : User -> Model -> ( Model, Cmd Msg )
fetchedTracksForUser user model =
    let
        newUser =
            if user.page >= user.totalPages then
                calculateUserStats user
            else
                user

        newUsers =
            model.users
                |> replaceItemInList .name newUser
                |> sortByFlip .playCount

        newCmd =
            if newUser.page < newUser.totalPages then
                getUserTracks model newUser (newUser.page + 1)
            else
                Cmd.none
    in
        ( { model | users = newUsers }, newCmd )


calculateUserStats : User -> User
calculateUserStats user =
    { user
        | artistCount = uniqueArtists user
        , albumCount = uniqueAlbums user
        , trackCount = uniqueTracks user
    }


getUserTracks : Model -> User -> Int -> Cmd Msg
getUserTracks model user page =
    let
        aWeekAgo =
            weekAgo model.flags.now
    in
        getRecentTracks model.flags.apiKey user aWeekAgo page


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
