module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList, placeholder, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (Sitemap(..))
import ViewUtils exposing (..)
import Leaderboard.View


view : Model -> Html Msg
view model =
    div [ class "ph6-ns ph4-m ph3" ]
        [ div [ class "full" ] [ page model ]
        , footer
        ]



-- Router


page : Model -> Html Msg
page model =
    case model.route of
        HomeRoute ->
            homeView model

        AboutRoute ->
            aboutView model

        LeaderboardRoute _ ->
            leaderboardView model

        NotFoundRoute ->
            notFoundView


header : Model -> Html Msg
header model =
    div [ class "header bold" ]
        [ div []
            [ h1 [ class "f-subheadline-ns f1 measure mv4 pointer", onClick ShowHome ]
                [ text "LastFm"
                , br [] []
                , text "Leaderboards"
                ]
            , nameInput model
            ]
        ]


shortcuts : Html Msg
shortcuts =
    let
        shortnames =
            "coffee_cups+bigtunaflops+sp00kyluke+i_am_tyson+aleeshak"

        shortnamesDisplay =
            shortnames
                |> String.split "+"
                |> String.join ", "
    in
        div [ class "shortcuts pv2" ]
            [ h3 [ class "f3" ] [ text "Shortcuts" ]
            , a [ href <| "/lb/" ++ shortnames, class "none" ]
                [ text shortnamesDisplay
                ]
            ]


nameInput : Model -> Html Msg
nameInput model =
    form [ onSubmit ShowLeaderboard ]
        [ div [ class "user-input input-group input-group--rightButton" ]
            [ input
                [ placeholder "Enter lastfm usernames separated by a comma"
                , onInput UsersStringChange
                , value model.usersString
                ]
                [ text model.usersString ]
            , button [ class "button button--primary" ] [ text "Go" ]
            ]
        ]


footer : Html Msg
footer =
    div [ class "footer pv5" ]
        [ p [ class "f5" ]
            [ text "made with ♥ by "
            , a [ href "https://jakerunzer.com", class "pointer" ]
                [ text "jake runzer" ]
            ]
        ]



-- Routes


homeView : Model -> Html Msg
homeView model =
    div [ class "full vertical-center" ]
        [ div []
            [ header model
            , shortcuts
            ]
        ]


aboutView : Model -> Html Msg
aboutView model =
    div [ class "about" ]
        [ headingLarge "About"
        , p [ class "measure" ] [ text "About this site." ]
        , a [ onClick ShowHome, class "f1 none dim" ] [ text "←" ]
        ]


leaderboardView : Model -> Html Msg
leaderboardView model =
    div [ class "leaderboard" ]
        [ header model
        , Leaderboard.View.view model
        ]


notFoundView : Html Msg
notFoundView =
    div [ class "not-found full vertical-center" ]
        [ div []
            [ h2 [ class "f2 mv4 mono" ] [ text "¯\\_(ツ)_/¯" ]
            , p [ class "measure" ]
                [ text "Page not found. "
                , a [ onClick ShowHome, class "pointer su-colour" ] [ text "Go home" ]
                , text "."
                ]
            ]
        ]
