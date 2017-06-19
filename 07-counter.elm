module Main exposing (..)

import Html exposing (Html, text, div, beginnerProgram, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type Msg
    = Increment
    | Decrement


type alias Model =
    Int


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ div [] [ text (toString model) ]
        , div [ class "btn-group" ]
            [ button
                [ class "btn btn-primary", onClick Increment ]
                [ text "+" ]
            , button
                [ class "btn btn-danger", onClick Decrement ]
                [ text "-" ]
            ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


main : Program Never Model Msg
main =
    beginnerProgram
        { model = 0
        , view = view
        , update = update
        }
