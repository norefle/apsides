module Views.UserPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Models.Types as Types
import Models.UserPage as UserPage
import Models.Change as Change
import Models.Code as Code
import Models.User as User
import Views.Components.ReviewSummary as Review
import Views.Components.ChangeSummary as Commit


view : UserPage.Model -> Html UserPage.Action
view model =
    div []
        [ div [ class "row" ]
            [ div [ class "col-md-3 text-center" ]
                [ profile model.user ]
            , div [ class "col-md-9" ]
                [ reviews model.reviews
                , commits model.commits
                ]
            ]
        ]


profile : User.User -> Html UserPage.Action
profile user =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ] [ text user.name ]
        , div [ class "panel-body" ]
            [ div [ class "row" ]
                [ img [ src user.userpic ] [] ]
            , div [ class "row text-left" ]
                [ topPackages user.packages 10
                ]
            , div [ class "row text-left" ]
                [ p [] [ text "Statistics (min | average | median | max)" ]
                , ul [ class "list-group" ]
                    [ statisticsItem "Files" user .files
                    , statisticsItem "Added lines" user .added
                    , statisticsItem "Removed lines" user .removed
                    ]
                ]
            ]
        ]


topPackages : List Change.Package -> Int -> Html UserPage.Action
topPackages list limit =
    p []
        [ text <| "Top " ++ (toString limit) ++ " packages (number of changes)"
        , ul [ class "list-group" ]
            (List.map
                packageItem
                (Types.sort Types.Desc compareByTouched list |> List.take limit)
            )
        ]


packageItem : Change.Package -> Html UserPage.Action
packageItem package =
    li [ class "list-group-item" ]
        [ span [ class "badge" ] [ text <| toString package.touched ]
        , a [ href package.url ] [ text package.name ]
        ]


statisticsItem : String -> User.User -> (User.Statistics -> Int) -> Html UserPage.Action
statisticsItem name user getValue =
    li [ class "list-group-item" ]
        [ span [ class "badge" ] [ text <| toString <| getValue user.max ]
        , span [ class "badge" ] [ text <| toString <| getValue user.median ]
        , span [ class "badge" ] [ text <| toString <| getValue user.average ]
        , span [ class "badge" ] [ text <| toString <| getValue user.min ]
        , text name
        ]


reviews : List Code.Review -> Html UserPage.Action
reviews list =
    summaryList "Reviews" Review.view list
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
