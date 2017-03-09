module Models.Page exposing (..)

import Time exposing (Time)
import Models.UserPage as UserPage
import Models.TeamPage as TeamPage
import Ports


type PageType
    = Team
    | User
    | Error


type Action
    = None
    | SetPage PageType
    | SetUser String
    | SetInput String
    | TimeUpdate Time
    | TeamAction TeamPage.Action
    | UserAction UserPage.Action


type alias Model =
    { pageType : PageType
    , teamPage : Maybe TeamPage.Model
    , userPage : Maybe UserPage.Model
    , error : Maybe String
    , input : String
    }


fromUserAction : UserPage.Action -> Action
fromUserAction userAction =
    UserAction userAction


fromTeamAction : TeamPage.Action -> Action
fromTeamAction teamAction =
    case teamAction of
        TeamPage.SetUser username ->
            SetUser username

        _ ->
            TeamAction teamAction


fromErrorAction : () -> Action
fromErrorAction _ =
    None


init : ( Model, Cmd Action )
init =
    ( { pageType = Team
      , teamPage = Nothing
      , userPage = Nothing
      , error = Nothing
      , input = ""
      }
    , Cmd.map TeamAction TeamPage.requestTeam
    )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        None ->
            ( model, Cmd.none )

        SetPage User ->
            ( { model | pageType = User }, Cmd.none )

        SetPage Team ->
            ( { model | pageType = Team }, Cmd.none )

        SetPage Error ->
            ( setError model "Not found", Cmd.none )

        SetUser name ->
            ( { model | pageType = User }
            , UserPage.requestUserAll name |> Cmd.map UserAction
            )

        SetInput input ->
            ( { model | input = input }, Cmd.none )

        TimeUpdate _ ->
            ( setError model "Not found", Cmd.none )

        TeamAction teamAction ->
            let
                teamModel =
                    Maybe.withDefault TeamPage.init model.teamPage

                ( newModel, changed ) =
                    TeamPage.update teamAction teamModel

                ( pageType, error ) =
                    case newModel.error of
                        Just _ ->
                            ( Error, newModel.error )

                        Nothing ->
                            ( Team, Nothing )
            in
                ( { model
                    | teamPage = Just newModel
                    , pageType = pageType
                    , error = error
                  }
                , Ports.hasUpdates changed
                )

        UserAction userAction ->
            let
                userModel =
                    Maybe.withDefault UserPage.init model.userPage

                ( newModel, changed ) =
                    UserPage.update userAction userModel

                ( pageType, error ) =
                    case newModel.error of
                        Just _ ->
                            ( Error, newModel.error )

                        Nothing ->
                            ( User, Nothing )
            in
                ( { model
                    | userPage = Just newModel
                    , pageType = pageType
                    , error = error
                  }
                , Ports.hasUpdates changed
                )


setError : Model -> String -> Model
setError model error =
    { model | pageType = Error, error = Just error }
