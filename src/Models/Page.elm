module Models.Page exposing (..)

import Models.Actions exposing (..)
import Models.Review as PageReview


type alias Model =
    { pageType : PageType
    , reviewData : PageReview.Model
    }


init : Model
init =
    { pageType = Review
    , reviewData = PageReview.init
    }


update : Action -> Model -> Model
update action model =
    case action of
        SetPage page ->
            { model | pageType = page }

        Idle ->
            model

        ReviewUpdateUserName _ ->
            updateReview action model

        ReviewUpdateUserPic _ ->
            updateReview action model

        ReviewUpdateCode _ ->
            updateReview action model


updateReview : Action -> Model -> Model
updateReview action model =
    { model | reviewData = PageReview.update action model.reviewData }
