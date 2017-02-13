module Views.Page exposing (..)

import Html exposing (Html)

import Models.Actions as A
import Models.Page exposing (Model)

import Views.Navbar as Navbar
import Views.Review as ReviewPage
import Views.Error as ErrorPage

view : Model -> Html A.Action
view model =
    Html.div [] [
        Navbar.view model,
        case model.pageType of
            A.Review -> ReviewPage.view model
            _ -> ErrorPage.view model
    ]
