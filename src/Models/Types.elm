module Models.Types exposing (..)

import Date exposing (fromTime)
import Date.Extra.Format exposing (utcIsoDateString)


type alias Updated =
    Bool


type SortOrder
    = Asc
    | Desc


inverseOrder : SortOrder -> SortOrder
inverseOrder current =
    if current == Asc then
        Desc
    else
        Asc


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


indexOf : (a -> Bool) -> List a -> Int
indexOf predicate list =
    let
        loop : (a -> Bool) -> Int -> List a -> Int
        loop predicate counter list =
            case list of
                [] ->
                    -1

                x :: xs ->
                    if predicate x then
                        counter
                    else
                        loop predicate (counter + 1) xs
    in
        loop predicate 0 list
