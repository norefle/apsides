module Models.Page exposing (..)

import Models.Actions exposing(..)
type alias Model = {
    pageType : PageType
    }

init : Model
init = { pageType = Review }

update : Action -> Model -> Model
update action model = case action of
    SetPage page -> { model | pageType = page }
    Idle -> model
