module Main exposing (..)

import Html exposing (..)
import Models.Page exposing (..)
import Views.Page exposing (..)

type alias Model = {
    page : Models.Page.Model
    }

type Msg = Init | Error

encode : Msg -> Models.Page.Action
encode msg = case msg of
    Init -> Models.Page.SetInitial
    Error -> Models.Page.SetError

decode : Models.Page.Action -> Msg
decode action = case action of
    Models.Page.SetInitial -> Init
    Models.Page.SetError -> Error

init : Model
init = { page = Models.Page.init }

update : Msg -> Model -> Model
update msg model =
    let
        pageMsg = encode msg
    in
        { model | page = Models.Page.update pageMsg model.page }

view : Model -> Html Msg
view model =
    Html.div [] [ Html.map decode <| Views.Page.view model.page ]

main : Program Never Model Msg
main = Html.beginnerProgram {
    model = init,
    update = update,
    view = view
    }

