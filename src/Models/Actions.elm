module Models.Actions exposing (..)

import Http exposing (Error)


type alias CodeChange =
    { package : String
    , added : Int
    , removed : Int
    , date : Int
    , description : String
    , url : String
    }


type alias UserSummary =
    { commits : Int
    , packages : Int
    , files : Int
    , lines : Int
    }


type alias User =
    { name : String
    , userpic : String
    , summary : UserSummary
    }


type alias Team =
    { users : List User
    , summary : UserSummary
    }


type alias Input =
    { name : String
    }


type alias ReviewModel =
    { user : User
    , changes : List CodeChange
    }


type PageType
    = Review
    | Retrospective
    | Planning
    | Error


type Action
    = Idle
    | SetPage PageType
    | ReviewUpdate (Result Http.Error ReviewModel)
    | ReviewTeamUpdate (Result Http.Error Team)
    | ReviewUpdateUserName String
    | ReviewUpdateChangeUser String
