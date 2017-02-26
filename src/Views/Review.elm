module Views.Review exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Round as Round
import Models.Actions as A
import Models.Review exposing (Model, CodeChange)


type ProgressType
    = Added
    | Removed


view : Model -> Html A.Action
view model =
    Html.div [ attribute "class" "row" ]
        [ Html.div [ attribute "class" "col-md-3 text-center" ]
            [ Html.div [ attribute "class" "panel panel-default" ]
                [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "User" ]
                , Html.div [ attribute "class" "panel-body" ]
                    [ Html.img [ attribute "src" ("img/" ++ model.user.userpic) ] []
                    , Html.text model.user.name
                    ]
                ]
            ]
        , Html.div [ attribute "class" "col-md-9" ]
            [ Html.div [ attribute "class" "panel panel-default" ]
                [ Html.div [ attribute "class" "panel-heading" ] [ Html.text "Code changes" ]
                , Html.div [ attribute "class" "panel-body" ]
                    [ (changeProgress Added model.total)
                    , (changeProgress Removed model.total)
                    ]
                ]
            ]
        ]


changeProgress : ProgressType -> CodeChange -> Html msg
changeProgress style changes =
    Html.div [ attribute "class" "progress" ]
        [ Html.div
            [ (progressType style)
            , attribute "role" "progressbar"
            , attribute "aria-valuenow" "75"
            , attribute "aria-valuemin" "0"
            , attribute "aria-valuemax" "100"
            , (progressWidth style changes)
            ]
            [ (progressTitle style changes) ]
        ]


progressType : ProgressType -> Html.Attribute msg
progressType style =
    case style of
        Added ->
            attribute "class" "progress-bar progress-bar-success progress-bar-striped"

        Removed ->
            attribute "class" "progress-bar progress-bar-danger progress-bar-striped"


progressTitle : ProgressType -> CodeChange -> Html msg
progressTitle style changes =
    let
        total =
            toFloat (changes.added + changes.removed)
    in
        case style of
            Added ->
                Html.text
                    ("Added: "
                        ++ (toString changes.added)
                        ++ " lines ("
                        ++ (percentage style changes)
                        ++ "%)"
                    )

            Removed ->
                Html.text
                    ("Removed: "
                        ++ (toString changes.removed)
                        ++ " lines ("
                        ++ (percentage style changes)
                        ++ "%)"
                    )


progressWidth : ProgressType -> CodeChange -> Html.Attribute msg
progressWidth style changes =
    let
        total =
            toFloat (changes.added + changes.removed)
    in
        case style of
            Added ->
                attribute "style" ("width: " ++ (percentage style changes) ++ "%")

            Removed ->
                attribute "style" ("width: " ++ (percentage style changes) ++ "%")


percentage : ProgressType -> CodeChange -> String
percentage style changes =
    let
        added =
            toFloat changes.added

        removed =
            toFloat changes.removed

        total =
            added + removed
    in
        case style of
            Added ->
                Round.round 0 <| (added / total) * 100

            Removed ->
                Round.round 0 <| (removed / total) * 100
