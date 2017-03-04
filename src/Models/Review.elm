module Models.Review exposing (..)

import Json.Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Models.Actions exposing (..)


type alias Model =
    ReviewModel


init : Model
init =
    { user =
        { name = "username"
        , userpic = "user.png"
        , summary =
            { commits = 0
            , packages = 0
            , files = 0
            , lines = 0
            , reviews = 0
            }
        }
    , changes = []
    , reviews = []
    }


update : Action -> Model -> Model
update action model =
    model


fromJsonUserSummary : Decoder UserSummary
fromJsonUserSummary =
    decode UserSummary
        |> optional "commits" int 0
        |> optional "packages" int 0
        |> optional "files" int 0
        |> optional "lines" int 0
        |> optional "reviews" int 0


fromJsonUser : Decoder User
fromJsonUser =
    decode User
        |> required "name" string
        |> required "avatar" string
        |> required "summary" fromJsonUserSummary


fromJsonChanges : Decoder CodeChange
fromJsonChanges =
    decode CodeChange
        |> required "package" string
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "last" int 0
        |> optional "description" string ""
        |> optional "url" string ""


fromJsonCodeReview : Decoder CodeReview
fromJsonCodeReview =
    decode CodeReview
        |> required "id" string
        |> required "url" string
        |> required "description" string
        |> optional "iteration" int 1
        |> optional "approved" int 0
        |> required "last" int


fromJsonReviews : Decoder (List CodeReview)
fromJsonReviews =
    decode (identity)
        |> required "reviews" (list fromJsonCodeReview)


fromJsonModel : Decoder ReviewModel
fromJsonModel =
    decode ReviewModel
        |> required "user" fromJsonUser
        |> required "changes" (list fromJsonChanges)
        |> hardcoded []


fromJsonTeam : Decoder Team
fromJsonTeam =
    decode Team
        |> required "users" (list fromJsonUser)
        |> hardcoded (UserSummary 0 0 0 0 0)
