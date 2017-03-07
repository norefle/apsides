module Main exposing (..)

import Html exposing (Html)
import Models.Actions exposing (Action)
import Models.Page as PageModel
import Views.Page as PageView
import Time exposing (Time)


type alias Model =
    { page : PageModel.Model
    }


init : ( Model, Cmd Action )
init =
    let
        ( pageModel, pageAction ) =
            PageModel.init
    in
        ( { page = pageModel }, pageAction )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    let
        ( pageModel, pageAction ) =
            PageModel.update action model.page
    in
        ( { model | page = pageModel }, pageAction )


view : Model -> Html Action
view model =
    Html.div [] [ PageView.view model.page ]


subscriptions : Model -> Sub Action
subscriptions model =
    Time.every (15 * Time.minute) Models.Actions.TimeUpdate


main : Program Never Model Action
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
