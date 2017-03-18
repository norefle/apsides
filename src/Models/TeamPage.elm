module Models.TeamPage exposing (..)

import Http
import Models.Team as Team
import Models.Calendar as Calendar
import Models.Code as Code
import Models.Types as Types
import Time exposing (Time)
import Date exposing (Date)
import Task


type Action
    = None
    | UpdateTeam (Result Http.Error Team.Team)
    | UpdateReviews String (Result Http.Error (List Code.Review))
    | UpdateTime Time
    | SetUser String


type alias Review =
    ( String, Code.Review )


type alias Model =
    { team : Team.Team
    , reviews : List Review
    , calendar : Calendar.Activity
    , today : Date
    , error : Maybe String
    }


init : Model
init =
    { team = { users = [], activities = [] }
    , reviews = []
    , calendar = Calendar.empty
    , today = Date.fromTime 0
    , error = Nothing
    }


update : Action -> Model -> ( Model, Types.Updated, Cmd Action )
update action model =
    case action of
        None ->
            ( model, False, Cmd.none )

        UpdateTeam (Ok team) ->
            ( { model
                | team = team
                , reviews = []
                , calendar =
                    List.foldl
                        (\activity calendar ->
                            Calendar.combineDates
                                ( activity.date, activity.commits )
                                calendar
                        )
                        Calendar.empty
                        team.activities
              }
            , model.team /= team
            , Cmd.batch [ requestAllReviews team.users, requestTime ]
            )

        UpdateTeam (Err error) ->
            ( { model | error = Just (toString error) }, True, Cmd.none )

        UpdateReviews username (Ok reviews) ->
            let
                newReviews =
                    List.map (\review -> ( username, review )) reviews

                compareReview =
                    \( leftName, leftReview ) ( rightName, rightReview ) ->
                        case Code.compareReview leftReview rightReview of
                            EQ ->
                                compare leftName rightName

                            result ->
                                result

                allReviews =
                    newReviews
                        |> List.append model.reviews
                        |> Types.sort Types.Desc compareReview
            in
                ( { model | reviews = allReviews }, True, Cmd.none )

        UpdateReviews _ (Err error) ->
            ( { model | error = Just (toString error) }, True, Cmd.none )

        UpdateTime today ->
            ( { model | today = Date.fromTime today }, False, Cmd.none )

        SetUser _ ->
            ( model, False, Cmd.none )


requestTime : Cmd Action
requestTime =
    Task.perform UpdateTime Time.now


requestTeam : Cmd Action
requestTeam =
    Http.get "/dashboard/team.json" Team.fromJsonToTeam
        |> Http.send UpdateTeam


requestAllReviews : List Team.User -> Cmd Action
requestAllReviews users =
    users
        |> List.filter (\user -> user.reviews /= 0)
        |> List.map (\user -> requestReviews user.name)
        |> Cmd.batch


requestReviews : String -> Cmd Action
requestReviews username =
    Http.get
        ("/dashboard/reviews/" ++ username ++ ".json")
        Code.fromJsonToListReview
        |> Http.send (UpdateReviews username)
