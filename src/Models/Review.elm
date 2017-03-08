module Models.Review exposing (..)

import Json.Decode exposing (Decoder, string, int, list, field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Models.Actions exposing (..)


type alias Model =
    ReviewModel


init : Model
init =
    { user =
        { name = "username"
        , userpic = "user.png"
        , packages = []
        , files = []
        , max = { files = 0, added = 0, removed = 0 }
        , min = { files = 0, added = 0, removed = 0 }
        , median = { files = 0, added = 0, removed = 0 }
        , average = { files = 0, added = 0, removed = 0 }
        }
    , changes = []
    , reviews = []
    }


update : Action -> Model -> Model
update action model =
    model


updateModel : (Model -> b -> Model) -> (Model -> b -> Bool) -> Maybe Model -> b -> ( Maybe Model, Bool )
updateModel apply check source newData =
    case source of
        Just sourceData ->
            ( apply sourceData newData |> Just, check sourceData newData )

        Nothing ->
            ( apply init newData |> Just, True )


updateUser : Maybe Model -> UserDetails -> ( Maybe Model, Bool )
updateUser maybe user =
    updateModel (\x y -> { x | user = y }) (\x y -> x.user /= y) maybe user


updateUserDetails : Maybe Model -> UserDetails -> ( Maybe Model, Bool )
updateUserDetails maybe user =
    updateModel (\x y -> { x | user = y }) (\x y -> x.user /= y) maybe user


updateChanges : Maybe Model -> List CodeChange -> ( Maybe Model, Bool )
updateChanges maybe changes =
    updateModel (\x y -> { x | changes = y }) (\x y -> x.changes /= y) maybe changes


updateReviews : Maybe Model -> List CodeReview -> ( Maybe Model, Bool )
updateReviews maybe reviews =
    updateModel (\x y -> { x | reviews = y }) (\x y -> x.reviews /= y) maybe reviews


fromJsonUserSummary : Decoder UserSummary
fromJsonUserSummary =
    decode UserSummary
        |> required "name" string
        |> optional "commits" int 0
        |> optional "packages" int 0
        |> optional "files" int 0
        |> optional "lines" int 0
        |> optional "reviews" int 0


fromJsonCodeChange : Decoder CodeChange
fromJsonCodeChange =
    decode CodeChange
        |> required "package" string
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "last" int 0
        |> optional "description" string ""
        |> optional "url" string ""


fromJsonChanges : Decoder (List CodeChange)
fromJsonChanges =
    decode (identity)
        |> required "changes" (list fromJsonCodeChange)


fromJsonCodeReview : Decoder CodeReview
fromJsonCodeReview =
    decode CodeReview
        |> required "id" string
        |> required "url" string
        |> required "description" string
        |> optional "iteration" int 1
        |> optional "approved" int 0
        |> required "last" int


fromJsonReviews : Decoder (List CodeReview)
fromJsonReviews =
    decode (identity)
        |> required "reviews" (list fromJsonCodeReview)


fromJsonTeam : Decoder Team
fromJsonTeam =
    decode Team
        |> required "users" (list fromJsonUserSummary)


fromJsonStatisticsNamed : String -> Decoder Statistics
fromJsonStatisticsNamed name =
    field name fromJsonStatistics


fromJsonStatistics : Decoder Statistics
fromJsonStatistics =
    decode Statistics
        |> required "files" int
        |> required "added" int
        |> required "removed" int


fromJsonPackageDetails : Decoder PackageDetails
fromJsonPackageDetails =
    decode PackageDetails
        |> required "name" string
        |> required "url" string
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "touched" int 0
        |> optional "last.date" int 0
        |> optional "last.description" string ""


fromJsonFileDetails : Decoder FileDetails
fromJsonFileDetails =
    decode FileDetails
        |> required "name" string
        |> required "package" string
        |> optional "added" int 0
        |> optional "removed" int 0
        |> optional "touched" int 0
        |> optional "last.date" int 0
        |> optional "last.description" string ""


fromJsonUserDetails : Decoder UserDetails
fromJsonUserDetails =
    decode UserDetails
        |> required "name" string
        |> required "avatar" string
        |> required "packages" (list fromJsonPackageDetails)
        |> required "files" (list fromJsonFileDetails)
        |> required "statistics" (fromJsonStatisticsNamed "max")
        |> required "statistics" (fromJsonStatisticsNamed "min")
        |> required "statistics" (fromJsonStatisticsNamed "median")
        |> required "statistics" (fromJsonStatisticsNamed "average")
