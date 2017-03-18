module Models.UserPage exposing (..)

import Http
import Models.Types exposing (..)
import Models.User as User
import Models.Code as Code
import Models.Calendar as Calendar
import Date exposing (Date)
import Time exposing (Time)
import Task


type Action
    = None
    | UpdateUser (Result Http.Error User.User)
    | UpdateCommits (Result Http.Error (List Code.Commit))
    | UpdateReviews (Result Http.Error (List Code.Review))
    | UpdateTime Time


type alias Model =
    { user : User.User
    , commits : List Code.Commit
    , reviews : List Code.Review
    , activities : Calendar.Activity
    , today : Date
    , error : Maybe String
    }


init : Model
init =
    { user =
        { name = ""
        , userpic = ""
        , packages = []
        , files = []
        , max = User.Statistics 0 0 0
        , min = User.Statistics 0 0 0
        , median = User.Statistics 0 0 0
        , average = User.Statistics 0 0 0
        }
    , commits = []
    , reviews = []
    , activities = Calendar.empty
    , today = Date.fromTime 0
    , error = Nothing
    }


update : Action -> Model -> ( Model, Updated, Cmd Action )
update action model =
    case action of
        None ->
            ( model, False, Cmd.none )

        UpdateUser (Ok newUser) ->
            ( { model | user = newUser }, model.user /= newUser, requestTime )

        UpdateUser (Err error) ->
            ( { model | error = Just (toString error) }, False, Cmd.none )

        UpdateCommits (Ok newCommits) ->
            ( { model
                | commits = newCommits
                , activities = activities newCommits
              }
            , model.commits /= newCommits
            , Cmd.none
            )

        UpdateCommits (Err error) ->
            ( { model | error = Just (toString error) }, False, Cmd.none )

        UpdateReviews (Ok newReviews) ->
            ( { model | reviews = newReviews }, model.reviews /= newReviews, Cmd.none )

        UpdateReviews (Err error) ->
            ( { model | error = Just (toString error) }, False, Cmd.none )

        UpdateTime today ->
            ( { model | today = Date.fromTime today }, False, Cmd.none )


activities : List Code.Commit -> Calendar.Activity
activities commits =
    let
        commitsByDate =
            List.map (\commit -> ( Date.fromTime <| toFloat <| commit.date * 1000, 1 )) commits
    in
        Calendar.createActivity commitsByDate


requestTime : Cmd Action
requestTime =
    Task.perform UpdateTime Time.now


requestUser : String -> Cmd Action
requestUser username =
    Http.get
        ("/dashboard/users/" ++ username ++ ".json")
        User.fromJsonToUser
        |> Http.send UpdateUser


requestCommits : String -> Cmd Action
requestCommits username =
    Http.get
        ("/dashboard/commits/" ++ username ++ ".json")
        Code.fromJsonToListCommit
        |> Http.send UpdateCommits


requestReviews : String -> Cmd Action
requestReviews username =
    Http.get
        ("/dashboard/reviews/" ++ username ++ ".json")
        Code.fromJsonToListReview
        |> Http.send UpdateReviews


requestUserAll : String -> Cmd Action
requestUserAll username =
    Cmd.batch
        [ requestUser username
        , requestCommits username
        , requestReviews username
        ]
