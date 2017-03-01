module Views.Navbar exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick, onInput)
import Models.Page exposing (Model)
import Models.Actions as A


view : Model -> Html A.Action
view model =
    Html.node "nav"
        [ attribute "class" "navbar navbar-inverse" ]
        [ Html.div [ attribute "class" "container-fluid" ]
            [ Html.ul [ attribute "class" "nav navbar-nav" ]
                [ Html.li [] [ Html.a [ onClick (A.SetPage A.Review) ] [ Html.text "Review" ] ]
                , Html.li [] [ Html.a [ onClick (A.SetPage A.Retrospective) ] [ Html.text "Retrospective" ] ]
                , Html.li [] [ Html.a [ onClick (A.SetPage A.Planning) ] [ Html.text "Planning" ] ]
                ]
            , Html.ul [ attribute "class" "nav navbar-nav navbar-right from-group" ]
                [ Html.li []
                    [ Html.input
                        [ attribute "type" "text"
                        , attribute "placeholder" "username"
                        , attribute "class" "form-control"
                        , onInput A.ReviewUpdateUserName
                        ]
                        []
                    ]
                , Html.li []
                    [ Html.button
                        [ attribute "class" "btn btn-default"
                        , onClick (A.ReviewUpdateChangeUser model.updates.name)
                        ]
                        [ Html.text "Go" ]
                    ]
                ]
            ]
        ]
