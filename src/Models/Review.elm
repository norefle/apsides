module Models.Review exposing (..)

import Models.Actions exposing (..)


type alias CodeChange =
    { package : String
    , added : Int
    , removed : Int
    , date : String
    }


type alias User =
    { name : String
    , userpic : String
    }


type alias Model =
    { user : User
    , total : CodeChange
    , changes : List CodeChange
    }


init : Model
init =
    { user = { name = "@username", userpic = "user.png" }
    , total = { package = "Total", added = 1024, removed = 512, date = "Yesterday" }
    , changes =
        [ { package = "Apsides", added = 512, removed = 256, date = "Never" }
        , { package = "Leser", added = 512, removed = 256, date = "Tomorrow" }
        ]
    }


update : Action -> Model -> Model
update action model =
    case action of
        ReviewUpdateUserName name ->
            { model | user = { name = name, userpic = model.user.userpic } }

        ReviewUpdateUserPic url ->
            { model | user = { name = model.user.name, userpic = url } }

        ReviewUpdateCode document ->
            { model | changes = [] }

        _ ->
            model
