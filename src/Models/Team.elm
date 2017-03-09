module Models.Team exposing (User, Team, fromJsonToTeam)

import Json.Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias User =
    { name : String
    , commits : Int
    , reviews : Int
    , packages : Int
    , files : Int
    , lines : Int
    }


type alias Team =
    { users : List User }


fromJsonToUser : Decoder User
fromJsonToUser =
    decode User
        |> required "name" string
        |> optional "commits" int 0
        |> optional "reviews" int 0
        |> optional "packages" int 0
        |> optional "files" int 0
        |> optional "lines" int 0


fromJsonToTeam : Decoder Team
fromJsonToTeam =
    decode Team
        |> required "users" (list fromJsonToUser)
