module Views.Error exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Models.Actions exposing (Action)


view : Maybe a -> Html Action
view model =
    let
        error =
            case model of
                Just value ->
                    toString value

                Nothing ->
                    ""
    in
        Html.div
            [ attribute "class" "alert alert-danger"
            , attribute "role" "alert"
            ]
            [ Html.text ("404: " ++ error) ]
