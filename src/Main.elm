module Main exposing (..)

import Html exposing (Html)
import Models.Page as PageModel
import Views.Page as PageView
import Time exposing (Time)


type Action
    = None
    | PageAction PageModel.Action


type alias Model =
    PageModel.Model


init : ( Model, Cmd Action )
init =
    let
        ( model, action ) =
            PageModel.init
    in
        ( model, Cmd.map PageAction action )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        None ->
            ( model, Cmd.none )

        PageAction pageAction ->
            let
                ( newModel, newAction ) =
                    PageModel.update pageAction model
            in
                ( newModel, Cmd.map PageAction newAction )


view : Model -> Html Action
view model =
    Html.div []
        [ PageView.view model |> Html.map PageAction ]


subscriptions : Model -> Sub Action
subscriptions model =
    Time.every (15 * Time.minute) PageModel.TimeUpdate
        |> Sub.map PageAction


main : Program Never Model Action
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
