module Models.Page exposing (..)

import Task exposing (perform)
import Http exposing (get, send)
import Models.Actions exposing (..)
import Models.Review as PageReview


type alias Model =
    { pageType : PageType
    , team : Maybe Team
    , reviewData : Maybe PageReview.Model
    , error : Maybe String
    , updates : Input
    }


init : ( Model, Cmd Action )
init =
    ( { pageType = Review
      , team = Nothing
      , reviewData = Nothing
      , error = Nothing
      , updates = { name = "" }
      }
    , Task.perform identity (Task.succeed (SetPage Review))
    )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        SetPage Review ->
            ( { model | pageType = Review }, requestTeam )

        SetPage page ->
            ( { model | pageType = page }, Cmd.none )

        Idle ->
            ( model, Cmd.none )

        ReviewTeamUpdate (Ok team) ->
            let
                firstUserName =
                    case List.head team.users of
                        Just user ->
                            user.name

                        Nothing ->
                            "username"
            in
                ( { model | team = Just { users = team.users, summary = summary team.users } }, requestReview firstUserName )

        ReviewTeamUpdate (Err value) ->
            ( { model | pageType = Error, error = Just (toString value) }, Cmd.none )

        ReviewUpdate (Ok user) ->
            ( { model | pageType = Review, reviewData = Just user }, Cmd.none )

        ReviewUpdate (Err value) ->
            ( { model | pageType = Error, error = Just (toString value) }, Cmd.none )

        ReviewUpdateUserName name ->
            ( { model | updates = { name = name } }, Cmd.none )

        ReviewUpdateChangeUser user ->
            case model.reviewData of
                Just data ->
                    ( model, requestReview user )

                Nothing ->
                    ( model, Cmd.none )


append : UserSummary -> UserSummary -> UserSummary
append left right =
    { commits = left.commits + right.commits
    , packages = left.packages + right.packages
    , files = left.files + right.files
    , lines = left.lines + right.lines
    }


summary : List User -> UserSummary
summary users =
    List.map (\user -> user.summary) users |> List.foldl append (UserSummary 0 0 0 0)


requestTeam : Cmd Action
requestTeam =
    Http.send ReviewTeamUpdate (Http.get "/dashboard/team.json" PageReview.fromJsonTeam)


requestReview : String -> Cmd Action
requestReview user =
    Http.send ReviewUpdate (Http.get ("/dashboard/" ++ user ++ ".json") PageReview.fromJsonModel)


updateReview : Action -> Model -> Model
updateReview action model =
    case model.reviewData of
        Just data ->
            { model | reviewData = Just <| PageReview.update action data }

        Nothing ->
            model
