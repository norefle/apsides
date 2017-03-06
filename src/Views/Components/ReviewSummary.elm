module Views.Components.ReviewSummary exposing (..)

import Html exposing (Html, div, text, span, pre, a)
import Html.Attributes exposing (attribute)
import Date exposing (fromTime)
import Date.Extra.Format exposing (utcIsoDateString)
import Models.Actions exposing (CodeReview)


view : CodeReview -> Html msg
view review =
    div []
        [ div [ attribute "class" "row" ]
            [ div [ attribute "class" "col-md-12" ]
                [ div [ attribute "class" "col-md-8" ]
                    [ a [ attribute "href" review.url ]
                        [ text review.id ]
                    ]
                , div [ attribute "class" "col-md-2 text-right" ]
                    [ text <| utcIsoDateString <| fromTime <| toFloat <| review.date * 1000 ]
                , div [ attribute "class" "col-md-2 text-right" ]
                    [ text "Approved: "
                    , span [ attribute "class" "badge" ]
                        [ text <| toString review.approved ]
                    ]
                ]
            ]
        , div [ attribute "class" "row" ]
            [ div [ attribute "class" "col-md-12" ]
                [ pre []
                    [ text review.description ]
                ]
            ]
        ]
