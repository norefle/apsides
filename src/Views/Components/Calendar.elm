module Views.Components.Calendar exposing (view)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Date exposing (Date, dayOfWeek)
import Dict exposing (Dict)
import Models.Calendar exposing (..)


view : Date -> Activity -> Svg ()
view current activity =
    let
        firstDay =
            getFirstDate weeksTotal current
    in
        svg
            [ width <| toString <| (weeksWidth weeksTotal) + 2 * weekDayNameWidth
            , height <| toString <| weekHeight + firstWeeksNameHeight
            ]
            ([ weekDayName 2 "Tue"
             , weekDayName 4 "Thu"
             , weekDayName 6 "Sat"
             ]
                ++ (List.range 0 (weeksTotal - 1) |> List.map (weekGroup activity firstDay))
                ++ (firstWeeks (weekDayNameWidth + cellMargin) firstDay weeksTotal)
            )


weekGroup : Activity -> Millis -> Int -> Svg ()
weekGroup activity base week =
    g
        [ transform
            ("translate("
                ++ (weekDayNameWidth + cellMargin + (cellSize + cellMargin) * week |> toString)
                ++ ","
                ++ ((cellSize + cellMargin) |> toString)
                ++ ")"
            )
        ]
        (List.range 0 6 |> List.map (cell activity base week))


cell : Activity -> Millis -> Int -> Int -> Svg ()
cell activity base week day =
    rect
        [ width <| toString cellSize
        , height <| toString cellSize
        , x "0"
        , y <| toString <| (cellSize + cellMargin) * day
        , fill <| getColor <| getCount activity <| getDate base <| getAbsoluteDayNumber day week
        ]
        []


weekDayName : Int -> String -> Svg ()
weekDayName index name =
    text_
        [ x "0"
        , y <| toString <| (cellSize + cellMargin) + index * (cellSize + cellMargin) - cellMargin
        , fontSize <| toString cellSize
        , fill "#c8c8c8"
        ]
        [ text name ]


firstWeeks : Int -> Millis -> Int -> List (Svg ())
firstWeeks from base weeks =
    getFirstWeeks base weeks
        |> List.map (firstWeekName from)


firstWeekName : Int -> FirstWeek -> Svg ()
firstWeekName from ( week, month ) =
    text_
        [ x <| toString <| from + week * (cellSize + cellMargin)
        , y <| toString cellSize
        , fontSize <| toString cellSize
        , fill "#c8c8c8"
        ]
        [ text <| toString month ]


getColor : Int -> String
getColor count =
    if count == 0 then
        "#c8c8c8"
    else if count < 5 then
        "#e8f4d0"
    else if count < 10 then
        "#c6e48b"
    else if count < 15 then
        "#7bc96f"
    else if count < 20 then
        "#239a3b"
    else
        "#196127"


getCount : Activity -> Millis -> Int
getCount activity date =
    activity
        |> Dict.get date
        |> Maybe.withDefault 0


cellSize : Int
cellSize =
    10


cellMargin : Int
cellMargin =
    2


weekDayNameWidth : Int
weekDayNameWidth =
    cellSize * 3 + cellMargin


weeksWidth : Int -> Int
weeksWidth count =
    (cellSize + cellMargin) * (count - 1) + cellSize


weekHeight : Int
weekHeight =
    (cellSize + cellMargin) * 6 + cellSize


firstWeeksNameHeight : Int
firstWeeksNameHeight =
    cellSize + cellMargin
