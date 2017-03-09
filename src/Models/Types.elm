module Models.Types exposing (..)

import Date exposing (fromTime)
import Date.Extra.Format exposing (utcIsoDateString)


type alias Updated =
    Bool


type SortOrder
    = Asc
    | Desc


sort : SortOrder -> (a -> a -> Order) -> List a -> List a
sort order cmp list =
    let
        compare =
            case order of
                Asc ->
                    cmp

                Desc ->
                    \x y -> cmp x y |> invert
    in
        List.sortWith compare list


invert : Order -> Order
invert order =
    case order of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


timestampToIso : Int -> String
timestampToIso time =
    (time * 1000)
        |> toFloat
        |> fromTime
        |> utcIsoDateString
