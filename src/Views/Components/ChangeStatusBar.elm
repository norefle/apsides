module Views.Components.ChangeStatusBar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, attribute)


view : Int -> Int -> Html ()
view added removed =
    let
        total =
            added + removed

        addedInPercent =
            percentage total added

        removeInPercent =
            100 - addedInPercent
    in
        div [ class "progress" ]
            [ div
                [ class "progress-bar progress-bar-success"
                , attribute "style" (styleWidth addedInPercent)
                ]
                [ text <| toString added ]
            , div
                [ class "progress-bar progress-bar-danger"
                , attribute "style" (styleWidth removeInPercent)
                ]
                [ text <| toString removed ]
            ]


styleWidth : Int -> String
styleWidth value =
    "width: " ++ (toString value) ++ "%"


percentage : Int -> Int -> Int
percentage total value =
    let
        ratio =
            (toFloat value / toFloat total) * 100.0
    in
        round ratio
