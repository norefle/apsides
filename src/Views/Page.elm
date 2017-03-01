module Views.Page exposing (..)

import Html exposing (Html)
import Models.Actions as A
import Models.Page exposing (Model)
import Views.Navbar as Navbar
import Views.Review as ReviewPage
import Views.Error as ErrorPage


view : Model -> Html A.Action
view model =
    Html.div []
        [ Navbar.view model
        , showPage model.pageType model.team model.reviewData model.error
        ]


showPage : A.PageType -> Maybe A.Team -> Maybe A.ReviewModel -> Maybe b -> Html A.Action
showPage page team model error =
    case page of
        A.Review ->
            case model of
                Just data ->
                    case team of
                        Just teamData ->
                            ReviewPage.view teamData data

                        Nothing ->
                            showEmptyPage

                Nothing ->
                    showEmptyPage

        _ ->
            showErrorPage error


showEmptyPage : Html A.Action
showEmptyPage =
    Html.div [] []


showErrorPage : Maybe a -> Html A.Action
showErrorPage error =
    ErrorPage.view error
