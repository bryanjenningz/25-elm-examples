module Main exposing (..)

import Html exposing (Html, text, div, beginnerProgram, input, button)
import Html.Attributes exposing (class, value, autofocus)
import Html.Events exposing (onInput, onClick)


type Msg
    = UpdateText String
    | AddTodo


type alias Model =
    { text : String
    , todos : List String
    }


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ input [ onInput UpdateText, value model.text, autofocus True ] []
        , button [ onClick AddTodo, class "btn btn-primary" ] [ text "Add Todo" ]
        , div [] (List.map (\todo -> div [] [ text todo ]) model.todos)
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateText newText ->
            { model | text = newText }

        AddTodo ->
            { model | text = "", todos = model.todos ++ [ model.text ] }


main : Program Never Model Msg
main =
    beginnerProgram
        { model = { text = "", todos = [] }
        , view = view
        , update = update
        }
