module Views.TeamPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Models.Team as Team
import Models.TeamPage as Page
import Views.Components.ReviewSummary as Review
import Views.Components.Calendar as Calendar
import Date exposing (Date)
import Models.Calendar as Calendar
import Models.Types as Types


view : Page.Model -> Html Page.Action
view model =
    div [ class "row" ]
        [ div [ class "col-md-4" ]
            [ teamSummary model.userOrder model.team.users ]
        , div [ class "col-md-8" ]
            [ calendarSummary model.today model.calendar
            , reviews model.reviews
            ]
        ]


calendarSummary : Date -> Calendar.Activity -> Html Page.Action
calendarSummary today activity =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "Active days "
            , span [ class "badge" ] [ text <| toString <| Calendar.length activity ]
            ]
        , div [ class "panel-body text-center" ]
            [ Calendar.view today activity |> Html.map translate ]
        ]


teamSummary : ( Page.SortBy, Types.SortOrder ) -> List Team.User -> Html Page.Action
teamSummary order users =
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
                    , td [ onClick (Page.SortUsers Page.Name) ] [ text <| headerName Name order ]
                    , td [ class "text-right", onClick (Page.SortUsers Page.Reviews) ] [ text <| headerName Reviews order ]
                    , td [ class "text-right", onClick (Page.SortUsers Page.Commits) ] [ text <| headerName Commits order ]
                    , td [ class "text-right", onClick (Page.SortUsers Page.Packages) ] [ text <| headerName Packages order ]
                    , td [ class "text-right", onClick (Page.SortUsers Page.Files) ] [ text <| headerName Files order ]
                    , td [ class "text-right", onClick (Page.SortUsers Page.Lines) ] [ text <| headerName Lines order ]
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
            , td [ class "text-right" ] [ text <| toString user.reviews ]
            , td [ class "text-right" ] [ text <| toString user.commits ]
            , td [ class "text-right" ] [ text <| toString user.packages ]
            , td [ class "text-right" ] [ text <| toString user.files ]
            , td [ class "text-right" ] [ text <| toString user.lines ]
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


type Header
    = Name
    | Reviews
    | Commits
    | Packages
    | Files
    | Lines


sortingPrefix : Types.SortOrder -> String
sortingPrefix order =
    case order of
        Types.Asc ->
            "△ "

        Types.Desc ->
            "▽ "


sortedBy : Header -> Page.SortBy -> Bool
sortedBy header by =
    case ( header, by ) of
        ( Name, Page.Name ) ->
            True

        ( Reviews, Page.Reviews ) ->
            True

        ( Commits, Page.Commits ) ->
            True

        ( Packages, Page.Packages ) ->
            True

        ( Files, Page.Files ) ->
            True

        ( Lines, Page.Lines ) ->
            True

        _ ->
            False


prefix : Header -> Page.SortBy -> Types.SortOrder -> String
prefix header by order =
    if sortedBy header by then
        sortingPrefix order
    else
        ""


headerName : Header -> ( Page.SortBy, Types.SortOrder ) -> String
headerName header order =
    case header of
        Name ->
            (uncurry (prefix header) order) ++ "username"

        Reviews ->
            (uncurry (prefix header) order) ++ "reviews"

        Commits ->
            (uncurry (prefix header) order) ++ "commits"

        Packages ->
            (uncurry (prefix header) order) ++ "packages"

        Files ->
            (uncurry (prefix header) order) ++ "files"

        Lines ->
            (uncurry (prefix header) order) ++ "lines"
