module Views.Page exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Models.Page as Page
import Views.Navbar as Navbar
import Views.UserPage as UserPage
import Views.TeamPage as TeamPage
import Views.ErrorPage as ErrorPage


view : Page.Model -> Html Page.Action
view model =
    div []
        [ Navbar.view model
        , div [ class "container-fluid" ]
            [ showPage model ]
        ]


showPage : Page.Model -> Html Page.Action
showPage model =
    case model.pageType of
        Page.User ->
            case model.userPage of
                Just data ->
                    UserPage.view data |> Html.map Page.fromUserAction

                Nothing ->
                    showEmptyPage

        Page.Team ->
            case model.teamPage of
                Just data ->
                    TeamPage.view data |> Html.map Page.fromTeamAction

                Nothing ->
                    showEmptyPage

        _ ->
            showErrorPage model.error


showEmptyPage : Html Page.Action
showEmptyPage =
    Html.div [] []


showErrorPage : Maybe a -> Html Page.Action
showErrorPage error =
    ErrorPage.view error |> Html.map Page.fromErrorAction
