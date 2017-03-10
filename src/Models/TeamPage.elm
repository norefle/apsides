module Models.TeamPage exposing (..)

import Http
import Models.Team as Team
import Models.Code as Code
import Models.Types exposing (..)


type Action
    = None
    | UpdateTeam (Result Http.Error Team.Team)
    | UpdateReviews String (Result Http.Error (List Code.Review))
    | SetUser String


type alias Review =
    ( String, Code.Review )


type alias Model =
    { team : Team.Team
    , reviews : List Review
    , error : Maybe String
    }


init : Model
init =
    { team = { users = [] }
    , reviews = []
    , error = Nothing
    }


update : Action -> Model -> ( Model, Updated, Cmd Action )
update action model =
    case action of
        None ->
            ( model, False, Cmd.none )

        UpdateTeam (Ok team) ->
            ( { model | team = team, reviews = [] }
            , model.team /= team
            , requestAllReviews team.users
            )

        UpdateTeam (Err error) ->
            ( { model | error = Just (toString error) }, True, Cmd.none )

        UpdateReviews username (Ok reviews) ->
            let
                newReviews =
                    List.map (\review -> ( username, review )) reviews

                allReviews =
                    List.append model.reviews newReviews
            in
                ( { model | reviews = allReviews }, True, Cmd.none )

        UpdateReviews _ (Err error) ->
            ( { model | error = Just (toString error) }, True, Cmd.none )

        SetUser _ ->
            ( model, False, Cmd.none )


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
