module Views.TeamPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Models.Team as Team
import Models.TeamPage as Page
import Views.Components.ReviewSummary as Review


view : Page.Model -> Html Page.Action
view model =
    div [ class "row" ]
        [ div [ class "col-md-12" ]
            [ teamSummary model.team.users ]
        , div [ class "col-md-12" ]
            [ reviews model.reviews
            ]
        ]


teamSummary : List Team.User -> Html Page.Action
teamSummary users =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ] [ text "Team" ]
        , table [ class "table table-striped" ]
            [ colgroup []
                [ col [] []
                , col [] []
                , col [] []
                , col [] []
                , col [] []
                , col [] []
                , col [] []
                ]
            , thead []
                [ tr []
                    [ td [] [ text "#" ]
                    , td [] [ text "username" ]
                    , td [] [ text "reviews" ]
                    , td [] [ text "commits" ]
                    , td [] [ text "packages" ]
                    , td [] [ text "files" ]
                    , td [] [ text "lines" ]
                    ]
                ]
            , tbody []
                (users
                    |> List.indexedMap (,)
                    |> List.map userSummary
                )
            ]
        ]


userSummary : ( Int, Team.User ) -> Html Page.Action
userSummary pair =
    let
        ( index, user ) =
            pair
    in
        tr []
            [ td [] [ text <| toString <| index + 1 ]
            , td []
                [ a [ href "#", onClick (Page.SetUser user.name) ]
                    [ text user.name ]
                ]
            , td [] [ text <| toString user.reviews ]
            , td [] [ text <| toString user.commits ]
            , td [] [ text <| toString user.packages ]
            , td [] [ text <| toString user.files ]
            , td [] [ text <| toString user.lines ]
            ]


reviews : List Page.Review -> Html Page.Action
reviews reviews =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "Reviews "
            , span [ class "badge" ]
                [ text <| toString <| List.length reviews ]
            ]
        , div [ class "panel-body" ]
            (List.map
                (\( username, review ) -> Review.view username review |> Html.map translate)
                reviews
            )
        ]


translate : () -> Page.Action
translate _ =
    Page.None
