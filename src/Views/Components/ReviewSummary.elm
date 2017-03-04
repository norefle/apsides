module Views.Components.ReviewSummary exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Date exposing (fromTime)
import Date.Extra.Format exposing (utcIsoDateString)
import Models.Actions exposing (CodeReview)


view : CodeReview -> Html msg
view review =
    Html.div []
        [ Html.div [ attribute "class" "row" ]
            [ Html.div [ attribute "class" "col-md-12" ]
                [ Html.div [ attribute "class" "col-md-9" ]
                    [ Html.a [ attribute "href" review.url ]
                        [ Html.text review.id ]
                    ]
                , Html.div [ attribute "class" "col-md-2 text-right" ]
                    [ Html.text <| utcIsoDateString <| fromTime <| toFloat <| review.date * 1000 ]
                , Html.div [ attribute "class" "col-md-1" ]
                    [ Html.span [ attribute "class" "badge" ]
                        [ Html.text <| toString review.approved ]
                    ]
                ]
            ]
        , Html.div [ attribute "class" "row" ]
            [ Html.div [ attribute "class" "col-md-12" ]
                [ Html.pre []
                    [ Html.text review.description ]
                ]
            ]
        ]
