module Views.Components.ChangeStatusBar exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Round exposing (round)


view : Int -> Int -> Html ()
view added removed =
    let
        total =
            added + removed
    in
        Html.div [ attribute "class" "progress" ]
            [ Html.div
                [ attribute "class" "progress-bar progress-bar-success"
                , attribute "style" (percentage total added)
                ]
                [ Html.text <| toString added ]
            , Html.div
                [ attribute "class" "progress-bar progress-bar-danger"
                , attribute "style" (percentage total removed)
                ]
                [ Html.text <| toString removed ]
            ]


percentage : Int -> Int -> String
percentage total value =
    let
        ratio =
            if total /= 0 then
                toFloat value / toFloat total
            else
                toFloat value
    in
        "width: " ++ (Round.floor 0 <| ratio * 100) ++ "%"
