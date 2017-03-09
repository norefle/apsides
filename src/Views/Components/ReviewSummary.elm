module Views.Components.ReviewSummary exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Models.Types as Types
import Models.Code as Code
import Models.Actions exposing (Action)


view : String -> Code.Review -> Html ()
view username review =
    div []
        [ div [ class "row" ]
            [ div [ class "col-md-12" ]
                [ div [ class "col-md-4" ]
                    [ text username ]
                , div [ class "col-md-3" ]
                    [ a [ href review.url ]
                        [ text review.id ]
                    ]
                , div [ class "col-md-2 text-right" ]
                    [ text <| Types.timestampToIso <| review.date ]
                , div [ class "col-md-3 text-right" ]
                    [ text "Approved: "
                    , span [ class "badge" ]
                        [ text <| toString review.approved ]
                    ]
                ]
            , div [ class "col-md-12" ]
                [ pre []
                    [ text review.description ]
                ]
            ]
        ]
