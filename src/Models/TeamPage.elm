module Models.TeamPage exposing (..)

import Http
import Models.Team as Team
import Models.Types exposing (..)


type Action
    = None
    | UpdateTeam (Result Http.Error Team.Team)
    | SetUser String


type alias Model =
    { team : Team.Team
    , error : Maybe String
    }


init : Model
init =
    { team = { users = [] }
    , error = Nothing
    }


update : Action -> Model -> ( Model, Updated )
update action model =
    case action of
        None ->
            ( model, False )

        UpdateTeam (Ok team) ->
            ( { model | team = team }, model.team /= team )

        UpdateTeam (Err error) ->
            ( { model | error = Just (toString error) }, False )

        SetUser _ ->
            ( model, False )


requestTeam : Cmd Action
requestTeam =
    Http.get "/dashboard/team.json" Team.fromJsonToTeam
        |> Http.send UpdateTeam
