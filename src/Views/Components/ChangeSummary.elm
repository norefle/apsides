module Views.Components.ChangeSummary exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Models.Types as Types
import Models.Code as Code
import Views.Components.ChangeStatusBar as Progressbar


view : Code.Commit -> Html ()
view commit =
    div [ class "row" ]
        [ div [ class "col-md-12" ]
            [ div [ class "col-md-7" ]
                [ a [ href commit.url ]
                    [ text commit.package ]
                ]
            , div [ class "col-md-2 text-right" ]
                [ text <| Types.timestampToIso commit.date ]
            , div [ class "col-md-3 text-right" ]
                [ Progressbar.view commit.added commit.removed ]
            ]
        , div [ class "col-md-12" ]
            [ pre [] [ text commit.description ] ]
        ]
