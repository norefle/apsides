module Views.Components.UserSummary exposing (..)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Models.Actions as A exposing (Action, User, UserSummary)
import Views.Components.Progressbar as Progressbar


view : UserSummary -> ( Int, User ) -> Html A.Action
view total indexedUser =
    let
        ( index, user ) =
            indexedUser
    in
        Html.tr []
            [ Html.td [] [ Html.text (toString index) ]
            , Html.td [] [ Html.a [ onClick (A.ReviewUpdateChangeUser user.name) ] [ Html.text user.name ] ]
            , Html.td [] [ Progressbar.view total.commits user.summary.commits ]
            , Html.td [] [ Progressbar.view total.packages user.summary.packages ]
            , Html.td [] [ Progressbar.view total.files user.summary.files ]
            , Html.td [] [ Progressbar.view total.lines user.summary.lines ]
            ]
