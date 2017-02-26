module Views.Review exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Models.Actions as A
import Models.Review exposing (Model, CodeChange)
import Views.Components.ChangeStatusBar as Progressbar
import Views.Components.ChangeSummary as Changes


view : Model -> Html A.Action
view model =
    Html.div []
        [ Html.div [ attribute "class" "row" ]
            [ Html.div [ attribute "class" "col-md-3 text-center" ]
                [ Html.div [ attribute "class" "panel panel-default" ]
                    [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "User" ]
                    , Html.div [ attribute "class" "panel-body" ]
                        [ Html.img [ attribute "src" ("img/" ++ model.user.userpic) ] []
                        , Html.text model.user.name
                        ]
                    ]
                ]
            , Html.div [ attribute "class" "col-md-9" ]
                [ Html.div [ attribute "class" "panel panel-default" ]
                    [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "Summary" ]
                    , Html.div [ attribute "class" "panel-body" ]
                        [ Progressbar.view model.total.added model.total.moved model.total.removed ]
                    ]
                ]
            ]
        , Html.div [ attribute "class" "row" ]
            [ Html.div [ attribute "class" "panel-default" ]
                [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "Changes" ]
                , Html.div [ attribute "class" "panel-body" ]
                    (List.map
                        Changes.view
                        model.changes
                    )
                ]
            ]
        ]
