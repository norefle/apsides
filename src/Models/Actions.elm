module Models.Actions exposing (..)

import Http exposing (Error)
import Time exposing (Time)
import Models.Code as Code
import Models.User as User
import Models.Team as Team


type Action
    = TimeUpdate Time
    | ReviewUpdateCodeChange (Result Http.Error (List Code.Commit))
    | ReviewUpdateCodeReview (Result Http.Error (List Code.Review))
    | ReviewUpdateUser (Result Http.Error User.User)
    | ReviewUpdateTeam (Result Http.Error Team.Team)
    | ReviewUpdateSetName String
    | ReviewUpdateSetUser String
