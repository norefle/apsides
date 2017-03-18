module Views.UserPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Date exposing (Date)
import Models.Types as Types
import Models.UserPage as UserPage
import Models.Change as Change
import Models.Code as Code
import Models.User as User
import Models.Calendar as Calendar
import Views.Components.ReviewSummary as Review
import Views.Components.ChangeSummary as Commit
import Views.Components.Calendar as Calendar


view : UserPage.Model -> Html UserPage.Action
view model =
    div [ class "row" ]
        [ div [ class "col-md-4 text-center" ]
            [ profile model.user ]
        , div [ class "col-md-8" ]
            [ activity model.today model.activities
            , reviews model.user.name model.reviews
            , commits model.commits
            ]
        ]


profile : User.User -> Html UserPage.Action
profile user =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text user.name ]
        , div [ class "panel-body" ]
            [ img [ src user.userpic ] [] ]
        , div [ class "well well-sm" ] [ text "Top 10 packages" ]
        , table [ class "table table-striped" ]
            [ colgroup []
                [ col [] []
                , col [] []
                ]
            , thead []
                [ tr []
                    [ td [ class "text-left" ] [ text "Package" ]
                    , td [ class "text-right" ] [ text "Commits" ]
                    ]
                ]
            , tbody []
                (topPackages user.packages 10)
            ]
        , div [ class "well well-sm" ] [ text "User statistics" ]
        , table [ class "table table-striped" ]
            [ colgroup []
                [ col [] []
                , col [] []
                , col [] []
                , col [] []
                , col [] []
                ]
            , thead []
                [ tr []
                    [ td [ class "text-left" ] [ text "Type" ]
                    , td [ class "text-right" ] [ text "Min" ]
                    , td [ class "text-right" ] [ text "Average" ]
                    , td [ class "text-right" ] [ text "Median" ]
                    , td [ class "text-right" ] [ text "Max" ]
                    ]
                ]
            , tbody []
                [ statisticsItem "Files" user .files
                , statisticsItem "Lines +" user .added
                , statisticsItem "Lines -" user .removed
                ]
            ]
        ]


topPackages : List Change.Package -> Int -> List (Html UserPage.Action)
topPackages list limit =
    Types.sort Types.Desc compareByTouched list
        |> List.take limit
        |> List.map packageItem


packageItem : Change.Package -> Html UserPage.Action
packageItem package =
    tr []
        [ td [ class "text-left" ] [ a [ href package.url ] [ text package.name ] ]
        , td [ class "text-right" ] [ text <| toString package.touched ]
        ]


statisticsItem : String -> User.User -> (User.Statistics -> Int) -> Html UserPage.Action
statisticsItem name user getValue =
    tr []
        [ td [ class "text-left" ] [ text name ]
        , td [ class "text-right" ] [ text <| toString <| getValue user.min ]
        , td [ class "text-right" ] [ text <| toString <| getValue user.average ]
        , td [ class "text-right" ] [ text <| toString <| getValue user.median ]
        , td [ class "text-right" ] [ text <| toString <| getValue user.max ]
        ]


activity : Date -> Calendar.Activity -> Html UserPage.Action
activity today activity =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "Activities "
            , span [ class "badge" ] [ text <| toString <| Calendar.length activity ]
            ]
        , div [ class "panel-body text-center" ]
            [ Calendar.view today activity |> Html.map translate ]
        ]


reviews : String -> List Code.Review -> Html UserPage.Action
reviews username list =
    summaryList "Reviews" (Review.view username) list
        |> Html.map translate


commits : List Code.Commit -> Html UserPage.Action
commits list =
    summaryList "Commits" Commit.view list
        |> Html.map translate


summaryList : String -> (a -> Html ()) -> List a -> Html ()
summaryList headline summary list =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text <| headline ++ " "
            , span [ class "badge" ] [ text <| toString <| List.length list ]
            ]
        , div [ class "panel-body" ]
            (List.map summary list)
        ]


translate : () -> UserPage.Action
translate _ =
    UserPage.None


compareByTouched : Change.Package -> Change.Package -> Order
compareByTouched left right =
    compare left.touched right.touched
