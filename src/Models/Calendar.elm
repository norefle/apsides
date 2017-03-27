module Models.Calendar exposing (..)

import Date exposing (Date)
import Date.Extra.Duration as Duration
import Time
import Dict exposing (Dict)
import Models.Types as Types


type alias Millis =
    Float


type alias Activity =
    Dict Millis Int


type alias DayNumber =
    Int


type alias WeekNumber =
    Int


type alias FirstWeek =
    ( WeekNumber, Date.Month )


empty : Activity
empty =
    Dict.empty


length : Activity -> Int
length activity =
    Dict.size activity


daysTotal : Int
daysTotal =
    365


weeksTotal : Int
weeksTotal =
    (daysTotal // 7) + 1


oneMinute : Millis
oneMinute =
    1000 * 60


oneHour : Millis
oneHour =
    oneMinute * 60


oneDay : Millis
oneDay =
    oneHour * 24


oneWeek : Millis
oneWeek =
    oneDay * 7


createActivity : List ( Date, Int ) -> Activity
createActivity dates =
    List.foldl
        combineDates
        Dict.empty
        dates


combineDates : ( Date, Int ) -> Activity -> Activity
combineDates ( date, count ) calendar =
    calendar
        |> Dict.update
            (removeTime date)
            (\value ->
                case value of
                    Just currentCount ->
                        Just (currentCount + count)

                    Nothing ->
                        Just count
            )


toMillis : Date -> Millis
toMillis date =
    date |> Date.toTime |> Time.inMilliseconds


removeTime : Date -> Millis
removeTime date =
    let
        hours =
            (Date.hour date |> toFloat) * oneHour

        minutes =
            (Date.minute date |> toFloat) * oneMinute

        seconds =
            (Date.second date |> toFloat) * 1000

        milliseconds =
            Date.millisecond date |> toFloat

        timeInMillis =
            hours + minutes + seconds + milliseconds
    in
        (toMillis date) - timeInMillis


fromMillis : Millis -> Date
fromMillis milliseconds =
    Date.fromTime milliseconds


getFirstDate : Int -> Date -> Millis
getFirstDate weeksTotal today =
    let
        days =
            [ Date.Mon, Date.Tue, Date.Wed, Date.Thu, Date.Fri, Date.Sat, Date.Sun ]

        currentWeekDay =
            Date.dayOfWeek today

        offset =
            Types.indexOf (\weekDay -> currentWeekDay == weekDay) days

        todayInCalendar =
            (weeksTotal - 1) * 7 + offset
    in
        (removeTime today) - ((toFloat todayInCalendar) * oneDay)


getDate : Millis -> DayNumber -> Millis
getDate base day =
    base
        |> fromMillis
        |> Duration.add Duration.Day day
        |> removeTime


getFirstWeeks : Millis -> Int -> List FirstWeek
getFirstWeeks base totalWeeks =
    List.range 0 (totalWeeks - 1)
        |> List.map (\week -> ( week, monthOfWeek base week ))
        |> List.foldl weeksWithDifferentMonths ( monthOfWeek base 0, [] )
        |> Tuple.second


weeksWithDifferentMonths : FirstWeek -> ( Date.Month, List FirstWeek ) -> ( Date.Month, List FirstWeek )
weeksWithDifferentMonths ( week, current ) ( previous, acc ) =
    let
        newAcc =
            if previous /= current then
                acc ++ [ ( week, current ) ]
            else
                acc
    in
        ( current, newAcc )


monthOfWeek : Millis -> WeekNumber -> Date.Month
monthOfWeek base week =
    getAbsoluteDayNumber 6 week |> getDate base |> fromMillis |> Date.month


getAbsoluteDayNumber : DayNumber -> WeekNumber -> DayNumber
getAbsoluteDayNumber day week =
    day + week * 7
