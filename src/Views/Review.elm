module Views.Review exposing (..)

import Html exposing (Html)
import Html.Attributes exposing(attribute)

import Models.Actions as A
import Models.Page exposing (Model)

view : Model -> Html A.Action
view model =
    Html.div [attribute "class" "row"] [
        Html.div [attribute "class" "col-md-3 text-center"] [
            Html.div [attribute "class" "panel panel-default"] [
                Html.div [attribute "class" "panel-heading"] [ Html.text "User"],
                Html.div [attribute "class" "panel-body"] [
                    Html.img [attribute "src" "img/user.png"][],
                    Html.text "@username"
                ]
            ]
        ],
        Html.div [attribute "class" "col-md-9"] [
            Html.div [attribute "class" "panel panel-default"] [
                Html.div [attribute "class" "panel-heading"] [ Html.text "Code changes"],
                Html.div [attribute "class" "panel-body"] [
                    Html.div [attribute "class" "progress"] [
                        Html.div [
                            attribute "class" "progress-bar progress-bar-success progress-bar-striped",
                            attribute "role" "progressbar",
                            attribute "aria-valuenow" "75",
                            attribute "aria-valuemin" "0",
                            attribute "aria-valuemax" "100",
                            attribute "style" "width: 75%"
                        ] [
                            Html.text "Added: 1234 lines (75%)"
                        ]
                    ],
                    Html.div [attribute "class" "progress"] [
                        Html.div [
                            attribute "class" "progress-bar progress-bar-danger progress-bar-striped",
                            attribute "role" "progressbar",
                            attribute "aria-valuenow" "60",
                            attribute "aria-valuemin" "0",
                            attribute "aria-valuemax" "100",
                            attribute "style" "width: 60%"
                        ] [
                            Html.text "Removed: 763 lines (60%)"
                        ]
                    ]
                ]
            ]
        ]
    ]
