module Views.Components.ChangeStatusBar exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Round exposing (round)


view : Int -> Int -> Int -> Html msg
view added moved removed =
    let
        total =
            added + moved + removed
    in
        Html.div [ attribute "class" "progress" ]
            [ Html.div
                [ attribute "class" "progress-bar progress-bar-success progress-bar-striped"
                , attribute "style" (percentage total added)
                ]
                [ Html.text <| "Added: " ++ (toString added) ++ " lines" ]
            , Html.div
                [ attribute "class" "progress-bar progress-bar-warning progress-bar-striped"
                , attribute "style" (percentage total moved)
                ]
                [ Html.text <| "Moved: " ++ (toString moved) ++ " lines" ]
            , Html.div
                [ attribute "class" "progress-bar progress-bar-danger progress-bar-striped"
                , attribute "style" (percentage total removed)
                ]
                [ Html.text <| "Deleted: " ++ (toString removed) ++ " lines" ]
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
