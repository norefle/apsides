module Models.User exposing (Statistics, User, fromJsonToUser)

import Json.Decode exposing (Decoder, string, int, list, field)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Models.Change as Change


type alias Statistics =
    { files : Int
    , added : Int
    , removed : Int
    }


type alias User =
    { name : String
    , userpic : String
    , packages : List Change.Package
    , files : List Change.File
    , max : Statistics
    , min : Statistics
    , median : Statistics
    , average : Statistics
    }


fromJsonToStatisticsNamed : String -> Decoder Statistics
fromJsonToStatisticsNamed name =
    field name fromJsonToStatistics


fromJsonToStatistics : Decoder Statistics
fromJsonToStatistics =
    decode Statistics
        |> required "files" int
        |> required "added" int
        |> required "removed" int


fromJsonToUser : Decoder User
fromJsonToUser =
    decode User
        |> required "name" string
        |> required "avatar" string
        |> required "packages" (list Change.fromJsonToPackage)
        |> required "files" (list Change.fromJsonToFile)
        |> required "statistics" (fromJsonToStatisticsNamed "max")
        |> required "statistics" (fromJsonToStatisticsNamed "min")
        |> required "statistics" (fromJsonToStatisticsNamed "median")
        |> required "statistics" (fromJsonToStatisticsNamed "average")
