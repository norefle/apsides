module Views.Navbar exposing (..)

import Html exposing(Html)
import Html.Attributes exposing(attribute)
import Html.Events exposing(onClick)

import Models.Page exposing(Model)
import Models.Actions as A

view : Model -> Html A.Action
view model =
    Html.node "nav" [attribute "class" "navbar navbar-inverse"] [
        Html.div [attribute "class" "container-fluid"] [
            Html.ul [attribute "class" "nav navbar-nav"] [
                Html.li [] [ Html.a [ onClick (A.SetPage A.Review) ] [Html.text "Review"]],
                Html.li [] [ Html.a [ onClick (A.SetPage A.Retrospective) ] [Html.text "Retrospective"]],
                Html.li [] [ Html.a [ onClick (A.SetPage A.Planning) ] [Html.text "Planning"]]
            ]
        ]
    ]
