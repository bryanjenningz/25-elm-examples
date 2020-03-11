module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (autofocus, class, value)
import Html.Events exposing (onClick, onInput)



-- We added a (RemoveTodo Int) value to the Msg type, which will allow us
-- to remove a todo by index.


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

                        -- We add a little "X" that we can click to remove
                        -- the todo at the specified index.
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

        -- We use a let expression to get the todos before and after, then
        -- we set the newTodos value to them concatenated together.
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


main : Program () Model Msg
main =
    sandbox
        { init = { text = "", todos = [] }
        , view = view
        , update = update
        }


-- Exercises to get to lesson 16
{-

The task at hand is to: (i) add some bootstrap classes to make things look a little more presentable.
Secondly, we wan add a place holder for the input - when we type new to dos in the field, a placeholder
would be helpful for users: https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#placeholder

If you are using elm make then you may have to get access to some bootstrap styles - add them to your
index.html page (or whatever you have named your page). Then run elm make src/Main.elm --debug
If you don't have an src directory, then you will have to create one. You will also have to name
your elm file Main.elm for the above to work.

-}
