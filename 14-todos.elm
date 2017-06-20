module Main exposing (..)

import Html exposing (Html, text, div, beginnerProgram, input, button)
import Html.Attributes exposing (class, value, autofocus)
import Html.Events exposing (onInput, onClick)


-- We added a new AddTodo message type.
type Msg
    = UpdateText String
    | AddTodo


-- We added a new property called todos, which is a list of strings.
type alias Model =
    { text : String
    , todos : List String
    }


-- We added (autofocus True), which is like the native HTML autofocus attribute.
-- We also added a button that triggers an onClick event when clicked which
-- passes an AddTodo message to the update function.
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

        -- We append the model.text value to the end of our list of todo strings.
        AddTodo ->
            { model | text = "", todos = model.todos ++ [ model.text ] }


-- We set the todos property so that it's initially an empty list.
main : Program Never Model Msg
main =
    beginnerProgram
        { model = { text = "", todos = [] }
        , view = view
        , update = update
        }
