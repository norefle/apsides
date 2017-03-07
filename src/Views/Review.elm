module Views.Review exposing (..)

import Html exposing (Html, div, img, text, col, td, span, tbody, tr, table, colgroup, ul, li, p, a)
import Html.Attributes exposing (attribute)
import Models.Actions exposing (Action, ReviewModel, Team, User)
import Views.Components.ChangeSummary as Changes
import Views.Components.ReviewSummary as Reviews
import Views.Components.UserSummary as UserSummary


view : Team -> ReviewModel -> Html Action
view team model =
    div []
        [ div [ attribute "class" "row" ]
            [ div [ attribute "class" "col-md-3 text-center" ]
                [ div [ attribute "class" "panel panel-default" ]
                    [ div [ attribute "class" "panel-heading" ] [ text model.user.name ]
                    , div [ attribute "class" "panel-body" ]
                        [ div [ attribute "class" "row" ]
                            [ img [ attribute "src" ("img/" ++ model.user.userpic) ] [] ]
                        , div [ attribute "class" "row text-left" ]
                            [ p [] [ text "Top 10 packages (number of changes)" ]
                            , ul [ attribute "class" "list-group" ]
                                (List.map
                                    (\x ->
                                        li [ attribute "class" "list-group-item" ]
                                            [ span [ attribute "class" "badge" ] [ text <| toString x.touched ]
                                            , a [ attribute "href" x.url ] [ text x.name ]
                                            ]
                                    )
                                    (List.take 10 model.details.packages)
                                )
                            ]
                        , div [ attribute "class" "row text-left" ]
                            [ p [] [ text "Statistics (min | average | median | max)" ]
                            , ul [ attribute "class" "list-group" ]
                                [ li [ attribute "class" "list-group-item" ]
                                    [ span [ attribute "class" "badge" ] [ text <| toString model.details.min.files ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.average.files ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.median.files ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.max.files ]
                                    , text "Files"
                                    ]
                                , li [ attribute "class" "list-group-item" ]
                                    [ span [ attribute "class" "badge" ] [ text <| toString model.details.min.added ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.average.added ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.median.added ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.max.added ]
                                    , text "Added lines"
                                    ]
                                , li [ attribute "class" "list-group-item" ]
                                    [ span [ attribute "class" "badge" ] [ text <| toString model.details.min.removed ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.average.removed ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.median.removed ]
                                    , span [ attribute "class" "badge" ] [ text <| toString model.details.max.removed ]
                                    , text "Removed lines"
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            , div [ attribute "class" "col-md-9" ]
                [ div [ attribute "class" "panel panel-default" ]
                    [ div [ attribute "class" "panel-heading" ] [ text "Team" ]
                    , div [ attribute "class" "panel-body" ]
                        [ table [ attribute "class" "table table-striped" ]
                            [ colgroup []
                                [ col [ attribute "class" "col-md-1" ] []
                                , col [ attribute "class" "col-md-3" ] []
                                , col [ attribute "class" "col-md-1" ] []
                                , col [ attribute "class" "col-md-1" ] []
                                , col [ attribute "class" "col-md-1" ] []
                                , col [ attribute "class" "col-md-1" ] []
                                , col [ attribute "class" "col-md-1" ] []
                                ]
                            , tbody []
                                ((tr []
                                    [ td [] [ text "#" ]
                                    , td [] [ text "username" ]
                                    , td [] [ text "reviews" ]
                                    , td [] [ text "commits" ]
                                    , td [] [ text "packages" ]
                                    , td [] [ text "files" ]
                                    , td [] [ text "lines" ]
                                    ]
                                 )
                                    :: List.map (UserSummary.view team.summary) (List.indexedMap (,) (List.sortWith getCommits team.users))
                                )
                            ]
                        ]
                    ]
                , div [ attribute "class" "panel panel-default" ]
                    [ div [ attribute "class" "panel-heading" ]
                        [ text "Code reviews "
                        , span [ attribute "class" "badge" ]
                            [ text <| toString model.user.summary.reviews ]
                        ]
                    , div [ attribute "class" "panel-body" ]
                        (List.map
                            Reviews.view
                            model.reviews
                        )
                    ]
                , div [ attribute "class" "panel panel-default" ]
                    [ div [ attribute "class" "panel-heading" ]
                        [ text "Changes "
                        , span [ attribute "class" "badge" ]
                            [ text <| toString <| List.length model.changes ]
                        ]
                    , div [ attribute "class" "panel-body" ]
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
