module Models exposing (..)

import Routing exposing (Sitemap)
import Flags exposing (Flags)
import Types exposing (User)


type alias Model =
    { route : Sitemap
    , flags : Flags
    , users : List User
    }


initialModel : Flags -> Sitemap -> Model
initialModel flags sitemap =
    { route = sitemap
    , flags = flags
    , users = []
    }
