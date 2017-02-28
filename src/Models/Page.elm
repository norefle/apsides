module Models.Page exposing (..)

import Task exposing (perform)
import Http exposing (get, send)
import Models.Actions exposing (..)
import Models.Review as PageReview


type alias Model =
    { pageType : PageType
    , reviewData : Maybe PageReview.Model
    , error : Maybe String
    , updates : Input
    }


init : ( Model, Cmd Action )
init =
    ( { pageType = Review
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
            ( { model | pageType = Review }, requestReview "username" )

        SetPage page ->
            ( { model | pageType = page }, Cmd.none )

        Idle ->
            ( model, Cmd.none )

        ReviewUpdate (Ok user) ->
            ( { model | pageType = Review, reviewData = Just user }, Cmd.none )

        ReviewUpdate (Err value) ->
            ( { model | pageType = Planning, error = Just (toString value) }, Cmd.none )

        ReviewUpdateUserName name ->
            ( { model | updates = { name = name } }, Cmd.none )

        ReviewUpdateChangeUser ->
            case model.reviewData of
                Just data ->
                    ( model, requestReview model.updates.name )
                Nothing ->
                    ( model, Cmd.none )


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
