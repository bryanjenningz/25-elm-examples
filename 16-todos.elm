module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (autofocus, class, placeholder, value)
import Html.Events exposing (onClick, onInput)


type Msg
    = UpdateText String
    | AddTodo
    | RemoveTodo Int


type alias Model =
    { text : String
    , todos : List String
    }



-- We added some nice little touches to the web app. We added a placeholder
-- attribute that's similar to the placeholder attribute you're used to with
-- native HTML.


view : Model -> Html Msg
view model =
    div [ class "col-12 col-sm-6 offset-sm-3" ]
        [ div [ class "row" ]
            [ div [ class "col-9" ]
                [ input
                    [ onInput UpdateText
                    , value model.text
                    , autofocus True
                    , class "form-control"
                    , placeholder "Enter a todo"
                    ]
                    []
                ]
            , div [ class "col-3" ]
                [ button
                    [ onClick AddTodo, class "btn btn-primary form-control" ]
                    [ text "+" ]
                ]
            ]
        , div [] (List.indexedMap viewTodo model.todos)
        ]



-- We made the styling nicer by taking advantage of Bootstrap classes.


viewTodo : Int -> String -> Html Msg
viewTodo index todo =
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ text todo
            , span
                [ onClick (RemoveTodo index)
                , class "float-right"
                ]
                [ text "✖" ]
            ]
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


main : Program () Model Msg
main =
    sandbox
        { init = { text = "", todos = [] }
        , view = view
        , update = update
        }



{-
Exercises to get to Lesson 17:

We want to be able to hit the enter button to add a todo.

How do we do this? 
To accomplish this, we wrap the input and button
in a form and made the AddTodo message get passed whenever an onSubmit
event gets triggered. The onSubmit event will get triggered whenever
the user hits enter in the input box or clicks on the button. Good luck and see you in lesson 17!

-}