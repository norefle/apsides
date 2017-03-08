module Views.Components.UserSummary exposing (..)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Models.Actions as A exposing (Action, UserSummary)


view : ( Int, UserSummary ) -> Html A.Action
view indexedUser =
    let
        ( index, user ) =
            indexedUser
    in
        Html.tr []
            [ Html.td [] [ Html.text (toString index) ]
            , Html.td [] [ Html.a [ onClick (A.ReviewUpdateSetUser user.name) ] [ Html.text user.name ] ]
            , Html.td [] [ Html.text <| toString user.reviews ]
            , Html.td [] [ Html.text <| toString user.commits ]
            , Html.td [] [ Html.text <| toString user.packages ]
            , Html.td [] [ Html.text <| toString user.files ]
            , Html.td [] [ Html.text <| toString user.lines ]
            ]
