module Views.TeamPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Models.Team as Team
import Models.TeamPage as Page


view : Page.Model -> Html Page.Action
view model =
    div [ class "col-md-12" ]
        [ div [ class "panel panel-default" ]
            [ div [ class "panel-heading" ] [ text "Team" ]
            , div [ class "panel-body" ]
                [ table [ class "table table-striped" ]
                    [ colgroup []
                        [ col [ class "col-md-1" ] []
                        , col [ class "col-md-6" ] []
                        , col [ class "col-md-1" ] []
                        , col [ class "col-md-1" ] []
                        , col [ class "col-md-1" ] []
                        , col [ class "col-md-1" ] []
                        , col [ class "col-md-1" ] []
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
                        (model.team.users
                            |> List.indexedMap (,)
                            |> List.map userSummary
                        )
                    ]
                ]
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
            , td [] [ a [ onClick (Page.SetUser user.name) ] [ text user.name ] ]
            , td [] [ text <| toString user.reviews ]
            , td [] [ text <| toString user.commits ]
            , td [] [ text <| toString user.packages ]
            , td [] [ text <| toString user.files ]
            , td [] [ text <| toString user.lines ]
            ]
