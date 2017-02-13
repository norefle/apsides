module Models.Page exposing (..)

type Action = SetInitial | SetError

type PageType = Initial | Error

type alias Model = {
    pageType : PageType
    }

init : Model
init = { pageType = Initial }

update : Action -> Model -> Model
update action model = case action of
    SetInitial -> { model | pageType = Initial }
    SetError -> { model | pageType = Error }
