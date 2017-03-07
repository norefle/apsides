module Models.Actions exposing (..)

import Http exposing (Error)
import Time exposing (Time)


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


type alias Statistics =
    { files : Int
    , added : Int
    , removed : Int
    }


type alias PackageDetails =
    { name : String
    , url : String
    , added : Int
    , removed : Int
    , touched : Int
    , date : Int
    , description : String
    }


type alias FileDetails =
    { name : String
    , package : String
    , added : Int
    , removed : Int
    , touched : Int
    , date : Int
    , description : String
    }


type alias UserDetails =
    { name : String
    , userpic : String
    , packages : List PackageDetails
    , files : List FileDetails
    , max : Statistics
    , min : Statistics
    , median : Statistics
    , average : Statistics
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
    , details : UserDetails
    , changes : List CodeChange
    , reviews : List CodeReview
    }


type PageType
    = Review
    | Retrospective
    | Planning
    | Error


type Action
    = TimeUpdate Time
    | SetPage PageType
    | ReviewUpdateCodeChange (Result Http.Error (List CodeChange))
    | ReviewUpdateCodeReview (Result Http.Error (List CodeReview))
    | ReviewUpdateUser (Result Http.Error UserDetails)
    | ReviewUpdateTeam (Result Http.Error Team)
    | ReviewUpdateSetName String
    | ReviewUpdateSetUser String
