module Views.Components.ChangeSummary exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Models.Actions exposing (CodeChange)
import Views.Components.ChangeStatusBar as Progressbar


view : CodeChange -> Html msg
view changes =
    Html.div [ attribute "class" "col-md-12" ]
        [ Html.div [ attribute "class" "col-md-10" ]
            [ Html.text changes.package ]
        , Html.div [ attribute "class" "col-md-2 text-right" ]
            [ Html.text changes.date
            ]
        , Html.div [ attribute "class" "col-md-12" ]
            [ Progressbar.view changes.added changes.moved changes.removed ]
        ]
