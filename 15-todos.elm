module Main exposing (..)

import Html exposing (Html, text, div, beginnerProgram, input, button, span)
import Html.Attributes exposing (class, value, autofocus)
import Html.Events exposing (onInput, onClick)


type Msg
    = UpdateText String
    | AddTodo
    | RemoveTodo Int


type alias Model =
    { text : String
    , todos : List String
    }


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ input [ onInput UpdateText, value model.text, autofocus True ] []
        , button
            [ onClick AddTodo, class "btn btn-primary" ]
            [ text "Add Todo" ]
        , div []
            (List.indexedMap
                (\index todo ->
                    div []
                        [ text todo
                        , span [ onClick (RemoveTodo index) ] [ text " X" ]
                        ]
                )
                model.todos
            )
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateText newText ->
            { model | text = newText }

        AddTodo ->
            { model | text = "", todos = model.todos ++ [ model.text ] }

        RemoveTodo index ->
            let
                beforeTodos =
                    List.take index model.todos

                afterTodos =
                    List.drop (index + 1) model.todos

                newTodos =
                    beforeTodos ++ afterTodos
            in
                { model | todos = newTodos }


main : Program Never Model Msg
main =
    beginnerProgram
        { model = { text = "", todos = [] }
        , view = view
        , update = update
        }
