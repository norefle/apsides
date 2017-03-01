module Views.Components.UserSummary exposing (..)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Models.Actions as A exposing (Action, User, UserSummary)


view : UserSummary -> ( Int, User ) -> Html A.Action
view total indexedUser =
    let
        ( index, user ) =
            indexedUser
    in
        Html.tr []
            [ Html.td [] [ Html.text (toString index) ]
            , Html.td [] [ Html.a [ onClick (A.ReviewUpdateChangeUser user.name) ] [ Html.text user.name ] ]
            , Html.td [] [ Html.text <| toString user.summary.reviews ]
            , Html.td [] [ Html.text <| toString user.summary.commits ]
            , Html.td [] [ Html.text <| toString user.summary.packages ]
            , Html.td [] [ Html.text <| toString user.summary.files ]
            , Html.td [] [ Html.text <| toString user.summary.lines ]
            ]
