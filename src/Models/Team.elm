module Models.Team exposing (User, Team, Activity, fromJsonToTeam)

import Json.Decode as Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional, resolve)
import Date exposing (Date)


type alias User =
    { name : String
    , commits : Int
    , reviews : Int
    , packages : Int
    , files : Int
    , lines : Int
    }


type alias Activity =
    { date : Date
    , commits : Int
    }


type alias Team =
    { users : List User
    , activities : List Activity
    }


fromJsonToUser : Decoder User
fromJsonToUser =
    decode User
        |> required "name" string
        |> optional "commits" int 0
        |> optional "reviews" int 0
        |> optional "packages" int 0
        |> optional "files" int 0
        |> optional "lines" int 0


fromJsonToDate : String -> Decoder Date
fromJsonToDate date =
    case Date.fromString date of
        Ok value ->
            Decode.succeed value

        Err err ->
            Decode.fail err


fromJsonToActivity : Decoder Activity
fromJsonToActivity =
    decode Activity
        |> required "date" (Decode.andThen fromJsonToDate string)
        |> required "commits" int


fromJsonToTeam : Decoder Team
fromJsonToTeam =
    decode Team
        |> required "users" (list fromJsonToUser)
        |> optional "activities" (list fromJsonToActivity) []
