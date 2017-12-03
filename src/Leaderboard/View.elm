module Leaderboard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (Sitemap(..))
import ViewUtils exposing (..)


view : Model -> Html Msg
view model =
    div [ class "leaderboards" ]
        [ headingLarge "Leaderboards" ]
