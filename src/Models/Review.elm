module Models.Review exposing (..)

import Json.Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Models.Actions exposing (..)


type alias Model =
    ReviewModel


init : Model
init =
    { user = { name = "username", userpic = "user.png" }
    , total = { package = "Total", added = 0, removed = 0, date = 0, description = "", url = "" }
    , changes = []
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
        |> optional "last" int 0
        |> optional "description" string ""
        |> optional "url" string ""


fromJsonModel : Decoder ReviewModel
fromJsonModel =
    decode ReviewModel
        |> required "user" fromJsonUser
        |> required "summary" fromJsonChanges
        |> required "changes" (list fromJsonChanges)
