module Models.Change exposing (..)

import Json.Decode exposing (Decoder, string, int)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias File =
    { name : String
    , package : String
    , date : Int
    , description : String
    , added : Int
    , removed : Int
    , touched : Int
    }


type alias Package =
    { name : String
    , url : String
    , date : Int
    , description : String
    , added : Int
    , removed : Int
    , touched : Int
    }


fromJsonToPackage : Decoder Package
fromJsonToPackage =
    decode Package
        |> required "name" string
        |> required "url" string
        |> optional "last.date" int 0
        |> optional "last.description" string ""
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "touched" int 0


fromJsonToFile : Decoder File
fromJsonToFile =
    decode File
        |> required "name" string
        |> required "package" string
        |> optional "last.date" int 0
        |> optional "last.description" string ""
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "touched" int 0
