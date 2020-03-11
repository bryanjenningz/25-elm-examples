module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (autofocus, class, value)
import Html.Events exposing (onClick, onInput)



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


main : Program () Model Msg
main =
    sandbox
        { init = { text = "", todos = [] }
        , view = view
        , update = update
        }

-- Exercises to 15:
{-
    Right now you cannot remove an item from the list.
    Let us add that ability. If we want to get rid of an item
    We should be able to click a button and remove it from the list.
    Hint: add a message called RemoveToDo (or something equivalent)
    and use the update function to remove that particular to do item
    from the model. In the view function,  you can add a little 'X'
    button such that when the user clicks it, the RemoveToDo message 
    is sent to the update fucntion. Good luck and see you in lesson 15!

-}