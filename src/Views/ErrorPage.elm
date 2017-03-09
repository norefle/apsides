module Views.ErrorPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, attribute)


view : Maybe a -> Html ()
view model =
    let
        error =
            model
                |> Maybe.andThen (toString >> Just)
                |> Maybe.withDefault ""
    in
        div
            [ class "alert alert-danger"
            , attribute "role" "alert"
            ]
            [ p []
                [ text "404: Error"
                , pre [] [ code [] [ text error ] ]
                ]
            ]
