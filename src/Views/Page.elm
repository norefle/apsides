module Views.Page exposing (..)

import Html exposing (..)
import Html.Attributes exposing(..)
import Models.Page as Model exposing (..)
import Views.Navbar as Navbar exposing(..)

view : Model.Model -> Html Model.Action
view model =
    let
        attr = Html.Attributes.attribute
    in
        Html.div [] [
            Navbar.view model,
            Html.div [attr "class" "row"] [
                Html.div [attr "class" "col-md-2 text-center"] [
                    --Html.div [attr "class" "panel panel-default"] [
                    --    Html.div [attr "class" "panel-heading"] [ Html.text "User"],
                    --    Html.div [attr "class" "panel-body"] [
                            Html.img [attr "src" "img/user.png"][],
                            Html.text "@username"
                    --    ]
                    --]
                ],
                Html.div [attr "class" "col-md-10"] [
                    Html.div [attr "class" "panel panel-default"] [
                        Html.div [attr "class" "panel-heading"] [ Html.text "Dashboard"],
                        Html.div [attr "class" "panel-body"] [
                            Html.div [attr "class" "progress"] [
                                Html.div [
                                    attr "class" "progress-bar progress-bar-success progress-bar-striped",
                                    attr "role" "progressbar",
                                    attr "aria-valuenow" "75",
                                    attr "aria-valuemin" "0",
                                    attr "aria-valuemax" "100",
                                    attr "style" "width: 75%"
                                ] [
                                    Html.text "Added: 1234 lines (75%)"
                                ]
                            ],
                            Html.div [attr "class" "progress"] [
                                Html.div [
                                    attr "class" "progress-bar progress-bar-danger progress-bar-striped",
                                    attr "role" "progressbar",
                                    attr "aria-valuenow" "60",
                                    attr "aria-valuemin" "0",
                                    attr "aria-valuemax" "100",
                                    attr "style" "width: 60%"
                                ] [
                                    Html.text "Removed: 763 lines (60%)"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
