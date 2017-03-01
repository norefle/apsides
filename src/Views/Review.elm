module Views.Review exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Models.Actions exposing (Action, ReviewModel, Team, User)
import Views.Components.ChangeSummary as Changes
import Views.Components.UserSummary as UserSummary


view : Team -> ReviewModel -> Html Action
view team model =
    Html.div []
        [ Html.div [ attribute "class" "row" ]
            [ Html.div [ attribute "class" "col-md-3 text-center" ]
                [ Html.div [ attribute "class" "panel panel-default" ]
                    [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "User" ]
                    , Html.div [ attribute "class" "panel-body" ]
                        [ Html.div [ attribute "class" "row" ]
                            [ Html.img [ attribute "src" ("img/" ++ model.user.userpic) ] [] ]
                        , Html.div [ attribute "class" "row" ]
                            [ Html.text model.user.name ]
                        , Html.div [ attribute "class" "row" ]
                            [ Html.text "Packages, commits, files, lines"
                            ]
                        ]
                    ]
                ]
            , Html.div [ attribute "class" "col-md-9" ]
                [ Html.div [ attribute "class" "panel panel-default" ]
                    [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "Team" ]
                    , Html.div [ attribute "class" "panel-body" ]
                        [ Html.table [ attribute "class" "table table-striped" ]
                            [ Html.colgroup []
                                [ Html.col [ attribute "class" "col-md-1" ] []
                                , Html.col [ attribute "class" "col-md-4" ] []
                                , Html.col [ attribute "class" "col-md-1" ] []
                                , Html.col [ attribute "class" "col-md-1" ] []
                                , Html.col [ attribute "class" "col-md-1" ] []
                                , Html.col [ attribute "class" "col-md-1" ] []
                                ]
                            , Html.tbody []
                                ((Html.tr []
                                    [ Html.td [] [ Html.text "#" ]
                                    , Html.td [] [ Html.text "username" ]
                                    , Html.td [] [ Html.text "commits" ]
                                    , Html.td [] [ Html.text "packages" ]
                                    , Html.td [] [ Html.text "files" ]
                                    , Html.td [] [ Html.text "line" ]
                                    ]
                                 )
                                    :: List.map (UserSummary.view team.summary) (List.indexedMap (,) (List.sortWith getCommits team.users))
                                )
                            ]
                        ]
                    ]
                ]
            ]
        , Html.div [ attribute "class" "row" ]
            [ Html.div [ attribute "class" "col-md-3" ] []
            , Html.div [ attribute "class" "col-md-9" ]
                [ Html.div [ attribute "class" "panel panel-default" ]
                    [ Html.div [ attribute "class" "panel-heading" ]
                        [ Html.text "Changes "
                        , Html.span [ attribute "class" "badge" ]
                            [ Html.text <| toString <| List.length model.changes ]
                        ]
                    , Html.div [ attribute "class" "panel-body" ]
                        (List.map
                            Changes.view
                            model.changes
                        )
                    ]
                ]
            ]
        ]


getCommits : User -> User -> Order
getCommits left right =
    case compare left.summary.commits right.summary.commits of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
