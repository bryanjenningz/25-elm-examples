module Main exposing (..)

import Html exposing (Html, text, div, beginnerProgram, input)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)


type Msg
    = UpdateText String


type alias Model =
    { text : String }


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ input [ onInput UpdateText, value model.text ] []
        , div [] [ text model.text ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateText newText ->
            { model | text = newText }


main : Program Never Model Msg
main =
    beginnerProgram
        { model = { text = "" }
        , view = view
        , update = update
        }
