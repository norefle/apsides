module Models.UserPage exposing (..)

import Http
import Models.Types exposing (..)
import Models.User as User
import Models.Code as Code


type Action
    = None
    | UpdateUser (Result Http.Error User.User)
    | UpdateCommits (Result Http.Error (List Code.Commit))
    | UpdateReviews (Result Http.Error (List Code.Review))


type alias Model =
    { user : User.User
    , commits : List Code.Commit
    , reviews : List Code.Review
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
    , error = Nothing
    }


update : Action -> Model -> ( Model, Updated )
update action model =
    case action of
        None ->
            ( model, False )

        UpdateUser (Ok newUser) ->
            ( { model | user = newUser }, model.user /= newUser )

        UpdateUser (Err error) ->
            ( { model | error = Just (toString error) }, False )

        UpdateCommits (Ok newCommits) ->
            ( { model | commits = newCommits }, model.commits /= newCommits )

        UpdateCommits (Err error) ->
            ( { model | error = Just (toString error) }, False )

        UpdateReviews (Ok newReviews) ->
            ( { model | reviews = newReviews }, model.reviews /= newReviews )

        UpdateReviews (Err error) ->
            ( { model | error = Just (toString error) }, False )


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
