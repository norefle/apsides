module Views.Components.ChangeSummary exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Date exposing (fromTime)
import Date.Extra.Format exposing (utcIsoDateString)
import Models.Actions exposing (CodeChange)
import Views.Components.ChangeStatusBar as Progressbar


view : CodeChange -> Html msg
view changes =
    Html.div [ attribute "class" "row" ]
        [ Html.div [ attribute "class" "col-md-12" ]
          [ Html.div [ attribute "class" "col-md-7" ]
              [ Html.a [ attribute "href" changes.url ]
                [ Html.text changes.package ]
              ]
          , Html.div [ attribute "class" "col-md-2 text-right" ]
              [ Html.text <| utcIsoDateString <| fromTime <| toFloat <| changes.date * 1000 ]
          , Html.div [ attribute "class" "col-md-3 text-right" ]
              [ Progressbar.view changes.added changes.removed ]
          ]
        , Html.div [ attribute "class" "col-md-12" ]
            [ Html.pre [ ] [ Html.text changes.description ] ]
        ]
