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


type alias CodeReview =
    { id : String
    , url : String
    , description : String
    , iteration : Int
    , approved : Int
    , date : Int
    }


type alias UserSummary =
    { commits : Int
    , packages : Int
    , files : Int
    , lines : Int
    , reviews : Int
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
    , reviews : List CodeReview
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
    | ReviewUpdateCodeReview (Result Http.Error (List CodeReview))
    | ReviewTeamUpdate (Result Http.Error Team)
    | ReviewUpdateUserName String
    | ReviewUpdateChangeUser String
