module Views.Error exposing (..)

import Html exposing (Html)
import Html.Attributes exposing(attribute)

import Models.Actions as A
import Models.Page exposing (Model)

view : Model -> Html A.Action
view model =
    Html.div [
        attribute "class" "alert alert-danger",
        attribute "role" "alert"
    ] [
        case model.pageType of
            A.Review -> Html.text "404: Review"
            A.Retrospective -> Html.text "404: Retrospective"
            A.Planning -> Html.text "404: Planning"
    ]
