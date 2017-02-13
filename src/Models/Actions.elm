module Models.Actions exposing (..)

type PageType = Review
    | Retrospective
    | Planning

type Action = Idle
    | SetPage PageType
