module Models.Actions exposing (..)

import Http exposing (Error)


type alias CodeChange =
    { package : String
    , added : Int
    , removed : Int
    , moved : Int
    , date : String
    }


type alias User =
    { name : String
    , userpic : String
    }


type alias ReviewModel =
    { user : User
    , total : CodeChange
    , changes : List CodeChange
    }


type PageType
    = Review
    | Retrospective
    | Planning


type Action
    = Idle
    | SetPage PageType
    | ReviewUpdate (Result Http.Error ReviewModel)
    | ReviewUpdateUserName String
    | ReviewUpdateUserPic String
    | ReviewUpdateCode String
