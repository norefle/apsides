module Views.Components.Calendar exposing (view)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Date exposing (Date, dayOfWeek)


view : List ( Date, Int ) -> Svg ()
view data =
    svg
        [ width <| toString <| cellSize * weeks + cellMargin * (weeks - 1)
        , height <| toString <| cellSize * 7 + cellMargin * 6
        ]
        (List.range 0 weeks |> List.map weekGroup)


weekGroup : Int -> Svg ()
weekGroup offset =
    g [ transform ("translate(" ++ ((cellSize + cellMargin) * offset |> toString) ++ ", 0)") ]
        (List.range 0 6 |> List.map cell)


cell : Int -> Svg ()
cell offset =
    rect
        [ width <| toString cellSize
        , height <| toString cellSize
        , x "0"
        , y <| toString <| (cellSize + cellMargin) * offset
        , fill "#cecece"
        ]
        []


days : Int
days =
    365


weeks : Int
weeks =
    days // 7 + 1


cellSize : Int
cellSize =
    10


cellMargin : Int
cellMargin =
    2
