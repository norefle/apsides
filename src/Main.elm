module Main exposing (..)

import Html exposing(Html)
import Models.Actions exposing (Action)
import Models.Page as PageModel
import Views.Page as PageView

type alias Model = {
    page : PageModel.Model
    }

init : (Model, Cmd Action)
init = ({ page = PageModel.init }, Cmd.none)

update : Action -> Model -> (Model, Cmd Action)
update action model =
        ({ model | page = PageModel.update action model.page }, Cmd.none)

view : Model -> Html Action
view model =
    Html.div [] [ PageView.view model.page ]

subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none

main : Program Never Model Action
main = Html.program {
    init = init,
    update = update,
    view = view,
    subscriptions = subscriptions
    }

