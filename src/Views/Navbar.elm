module Views.Navbar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, type_, href, placeholder)
import Html.Events exposing (onClick, onInput)
import Models.Page as Page


view : Page.Model -> Html Page.Action
view model =
    nav
        [ class "navbar navbar-inverse" ]
        [ div [ class "container-fluid" ]
            [ ul [ class "nav navbar-nav" ]
                [ li [] [ a [ href "#", onClick (Page.SetPage Page.Team) ] [ text "Dashboard" ] ]
                , li [] [ a [ href "#", onClick (Page.SetPage Page.User) ] [ text "User" ] ]
                ]
            , ul [ class "nav navbar-nav navbar-right from-group" ]
                [ li []
                    [ input
                        [ type_ "text"
                        , placeholder "username"
                        , class "form-control"
                        , onInput Page.SetInput
                        ]
                        []
                    ]
                , li []
                    [ button
                        [ class "btn btn-default"
                        , onClick (Page.SetUser model.input)
                        ]
                        [ text "Go" ]
                    ]
                ]
            ]
        ]
