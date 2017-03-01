module Views.Components.Progressbar exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Round exposing (round)


view : Int -> Int -> Html msg
view max value =
    let
        percents =
            percentage max value
    in
        Html.div [ attribute "class" "progress" ]
            [ Html.div
                [ attribute "class" "progress-bar progress-bar-success"
                , attribute "aria-valuenow" (toString value)
                , attribute "aria-valuemax" (toString max)
                , attribute "style" ("width: " ++ percents ++ "%")
                ]
                [ Html.text <| (toString value) ++ " (" ++ percents ++ "%)" ]
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
        Round.floor 0 <| ratio * 100
