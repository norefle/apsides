module Views.Navbar exposing (..)

import Html exposing(..)
import Html.Attributes exposing(..)
import Models.Page as Page exposing(Model, Action)

view : Page.Model -> Html Page.Action
view model =
    let
        attr = Html.Attributes.attribute
    in
        Html.node "nav" [attr "class" "navbar navbar-inverse"] [
            Html.div [attr "class" "container-fluid"] [
                Html.ul [attr "class" "nav navbar-nav"] [
                    Html.li [] [ Html.a [] [Html.text "Dashboard"]],
                    Html.li [] [ Html.a [] [Html.text "Retrospective"]],
                    Html.li [] [ Html.a [] [Html.text "Error"]]
                ]
            ]
    ]
