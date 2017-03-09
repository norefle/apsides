module Models.Code exposing (..)

import Json.Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias Commit =
    { id : String
    , date : Int
    , url : String
    , description : String
    , package : String
    , added : Int
    , removed : Int
    }


type alias Review =
    { id : String
    , date : Int
    , url : String
    , description : String
    , iteration : Int
    , approved : Int
    }


fromJsonToCommit : Decoder Commit
fromJsonToCommit =
    decode Commit
        |> required "id" string
        |> required "last" int
        |> required "url" string
        |> optional "description" string ""
        |> required "package" string
        |> optional "added" int 0
        |> optional "removed" int 0


fromJsonToReview : Decoder Review
fromJsonToReview =
    decode Review
        |> required "id" string
        |> required "last" int
        |> required "url" string
        |> optional "description" string ""
        |> optional "iteration" int 0
        |> optional "approved" int 0


fromJsonToListCommit : Decoder (List Commit)
fromJsonToListCommit =
    decode (identity)
        |> required "changes" (list fromJsonToCommit)


fromJsonToListReview : Decoder (List Review)
fromJsonToListReview =
    decode (identity)
        |> required "reviews" (list fromJsonToReview)
