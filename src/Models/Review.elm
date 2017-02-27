module Models.Review exposing (..)

import Json.Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Models.Actions exposing (..)


type alias Model =
    ReviewModel


init : Model
init =
    { user = { name = "username", userpic = "user.png" }
    , total = { package = "Total", added = 1024, moved = 346, removed = 512, date = "Yesterday" }
    , changes =
        [ { package = "Apsides", added = 512, moved = 112, removed = 256, date = "Never" }
        , { package = "Leser", added = 512, moved = 234, removed = 256, date = "Tomorrow" }
        ]
    }


update : Action -> Model -> Model
update action model =
    case action of
        ReviewUpdateUserName name ->
            { model | user = { name = name, userpic = model.user.userpic } }

        ReviewUpdateUserPic url ->
            { model | user = { name = model.user.name, userpic = url } }

        ReviewUpdateCode document ->
            { model | changes = [] }

        _ ->
            model


fromJsonUser : Decoder User
fromJsonUser =
    decode User
        |> required "name" string
        |> required "avatar" string


fromJsonChanges : Decoder CodeChange
fromJsonChanges =
    decode CodeChange
        |> required "package" string
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "moved" int 0
        |> optional "last" string "1970-01-01"


fromJsonModel : Decoder ReviewModel
fromJsonModel =
    decode ReviewModel
        |> required "user" fromJsonUser
        |> required "summary" fromJsonChanges
        |> required "changes" (list fromJsonChanges)
