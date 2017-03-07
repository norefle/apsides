module Models.Page exposing (..)

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
    , requestTeam
    )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        SetPage Review ->
            ( { model | pageType = Review }, requestTeam )

        SetPage page ->
            ( setError model "Not found", Cmd.none )

        Idle ->
            ( model, Cmd.none )

        ReviewUpdateTeam (Ok team) ->
            let
                initData =
                    PageReview.init

                firstUser =
                    case List.head team.users of
                        Just user ->
                            user

                        Nothing ->
                            initData.user
            in
                ( { model
                    | team = Just { users = team.users, summary = summary team.users }
                    , reviewData = PageReview.updateUser (Just initData) firstUser
                  }
                , Cmd.batch
                    [ requestUser firstUser.name
                    , requestReviews firstUser.name
                    , requestChanges firstUser.name
                    ]
                )

        ReviewUpdateTeam (Err value) ->
            ( setError model <| toString value, Cmd.none )

        ReviewUpdateSetName name ->
            ( { model | updates = { name = name } }, Cmd.none )

        ReviewUpdateSetUser user ->
            ( { model
                | pageType = Review
                , reviewData =
                    (updateUser model.reviewData <|
                        findUser model.team user
                    )
              }
            , Cmd.batch
                [ requestUser user
                , requestReviews user
                , requestChanges user
                ]
            )

        ReviewUpdateCodeReview (Ok reviews) ->
            ( { model | reviewData = PageReview.updateReviews model.reviewData reviews }
            , Cmd.none
            )

        ReviewUpdateCodeReview (Err value) ->
            ( setError model <| toString value, Cmd.none )

        ReviewUpdateCodeChange (Ok changes) ->
            ( { model | reviewData = PageReview.updateChanges model.reviewData changes }
            , Cmd.none
            )

        ReviewUpdateCodeChange (Err value) ->
            ( setError model <| toString value, Cmd.none )

        ReviewUpdateUser (Ok details) ->
            ( { model | reviewData = PageReview.updateUserDetails model.reviewData details }
            , Cmd.none
            )

        ReviewUpdateUser (Err value) ->
            ( setError model <| toString value, Cmd.none )


setError : Model -> String -> Model
setError model error =
    { model | pageType = Error, error = Just error }


append : UserSummary -> UserSummary -> UserSummary
append left right =
    { commits = left.commits + right.commits
    , packages = left.packages + right.packages
    , files = left.files + right.files
    , lines = left.lines + right.lines
    , reviews = left.reviews + right.reviews
    }


summary : List User -> UserSummary
summary users =
    List.map (\user -> user.summary) users |> List.foldl append (UserSummary 0 0 0 0 0)


requestTeam : Cmd Action
requestTeam =
    Http.send ReviewUpdateTeam (Http.get "/dashboard/team.json" PageReview.fromJsonTeam)


requestChanges : String -> Cmd Action
requestChanges user =
    Http.send
        ReviewUpdateCodeChange
        (Http.get
            ("/dashboard/commits/" ++ user ++ ".json")
            PageReview.fromJsonChanges
        )


requestReviews : String -> Cmd Action
requestReviews user =
    Http.send
        ReviewUpdateCodeReview
        (Http.get
            ("/dashboard/reviews/" ++ user ++ ".json")
            PageReview.fromJsonReviews
        )


requestUser : String -> Cmd Action
requestUser username =
    Http.send
        ReviewUpdateUser
        (Http.get
            ("/dashboard/users/" ++ username ++ ".json")
            PageReview.fromJsonUserDetails
        )


find : List a -> (a -> Bool) -> Maybe a
find xs predicate =
    case xs of
        [] ->
            Nothing

        head :: tail ->
            if (predicate head) then
                Just head
            else
                find tail predicate


findUser : Maybe Team -> String -> Maybe User
findUser team user =
    Maybe.andThen (\x -> find x.users (\item -> item.name == user)) team


updateUser : Maybe PageReview.Model -> Maybe User -> Maybe PageReview.Model
updateUser model user =
    case user of
        Just userData ->
            PageReview.updateUser model userData

        Nothing ->
            model
