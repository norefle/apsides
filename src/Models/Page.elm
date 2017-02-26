module Models.Page exposing (..)

import Task exposing (perform)
import Http exposing (get, send)
import Models.Actions exposing (..)
import Models.Review as PageReview


type alias Model =
    { pageType : PageType
    , reviewData : PageReview.Model
    , error : Maybe String
    }


init : ( Model, Cmd Action )
init =
    ( { pageType = Review
      , reviewData = PageReview.init
      , error = Nothing
      }
    , Task.perform identity (Task.succeed (SetPage Review))
    )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        SetPage Review ->
            ( { model | pageType = Review }, requestReview model.reviewData.user.name )

        SetPage page ->
            ( { model | pageType = page }, Cmd.none )

        Idle ->
            ( model, Cmd.none )

        ReviewUpdate (Ok user) ->
            ( { model | pageType = Review, reviewData = user }, Cmd.none )

        ReviewUpdate (Err value) ->
            ( { model | pageType = Planning, error = Just (toString value) }, Cmd.none )

        ReviewUpdateUserName _ ->
            ( updateReview action model, Cmd.none )

        ReviewUpdateUserPic _ ->
            ( updateReview action model, Cmd.none )

        ReviewUpdateCode _ ->
            ( updateReview action model, Cmd.none )


requestReview : String -> Cmd Action
requestReview user =
    Http.send ReviewUpdate (Http.get ("/dashboard/" ++ user ++ ".json") PageReview.fromJsonModel)


updateReview : Action -> Model -> Model
updateReview action model =
    { model | reviewData = PageReview.update action model.reviewData }
