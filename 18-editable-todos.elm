module Main exposing (main)

-- I got lazy exposing all of those functions from the Html module, so
-- I decided to use (..), which means that I'm exposing all the functions
-- from the Html module.

import Browser exposing (sandbox)
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, placeholder, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)



-- We added 2 new values to the Msg union type, (Edit Int String) and
-- (EditSave Int String). These values will be used to represent editing a todo.
-- The (Edit Int String) value is used for keeping track of the current todo
-- being edited. The Int represents the index of the todo and the String
-- represents the text for that todo.
-- The (EditSave Int String) value will be used to save the new value of the
-- todo. The Int is todo index, the string is the string we want to save that
-- todo as.


type Msg
    = UpdateText String
    | AddTodo
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String



-- We are creating a new type alias which is just a record that will represent
-- the editing state. The index property is the index of the todo we're editing
-- and the text is that todo's string value.


type alias TodoEdit =
    { index : Int
    , text : String
    }



-- We added a new property called editing, which will keep track of the editing
-- state. It's type is Maybe TodoEdit instead of just TodoEdit. We are using a
-- Maybe type which is similar to nullable values in JavaScript. The Maybe
-- equivalent of null is the Nothing value. When a Maybe value is not Nothing,
-- then it is Just something. For example, if I have a Maybe Int type, that means
-- it can be Nothing or it can be Just 1 or Just 2 or Just 3, etc. This will
-- make more sense when you get used to using Maybe types. Don't worry if it
-- doesn't make complete sense yet. Just think of Maybe types as nullable types
-- in JavaScript.


type alias Model =
    { text : String
    , todos : List String
    , editing : Maybe TodoEdit
    }


view : Model -> Html Msg
view model =
    div [ class "col-12 col-sm-6 offset-sm-3" ]
        [ form [ class "row", onSubmit AddTodo ]
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
                    [ class "btn btn-primary form-control" ]
                    [ text "+" ]
                ]
            ]

        -- We are using (viewTodo model.editing) as the function, that gets
        -- passed into List.indexedMap. All this means is that the first argument
        -- to viewTodo is model.editing, the remaining 2 arguments will be
        -- passed in by List.indexedMap.
        , div [] (List.indexedMap (viewTodo model.editing) model.todos)
        ]



-- We use a case expression to check the editing value, which is model.editing.
-- The editing value is a Maybe type, so it can either be Nothing or Just value.
-- If its value is Nothing, that means we aren't editing any todos.
-- If the value is (Just todoEdit), then we need to check to see if the index
-- that we're editing is the current index we're at, if it is, then we need
-- to return the viewEditTodo function with the appropriate arguments passed in.


viewTodo : Maybe TodoEdit -> Int -> String -> Html Msg
viewTodo editing index todo =
    case editing of
        Just todoEdit ->
            if todoEdit.index == index then
                viewEditTodo index todoEdit

            else
                viewNormalTodo index todo

        Nothing ->
            viewNormalTodo index todo



-- This is what a todo looks like when it's being edited. You can save edits
-- by hitting enter, which will trigger an onSubmit event, which will pass the
-- (EditSave todoEdit.index todoEdit.text) message to the update function.
-- Every time you change the text in the input box, the onInput event will take
-- the (Edit index) message add the current input box string to the end so
-- that it's like (Edit index editText), then pass that message to the update
-- function.


viewEditTodo : Int -> TodoEdit -> Html Msg
viewEditTodo index todoEdit =
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ form [ onSubmit (EditSave todoEdit.index todoEdit.text) ]
                [ input
                    [ onInput (Edit index)
                    , class "form-control"
                    , value todoEdit.text
                    ]
                    []
                ]
            ]
        ]



-- This is what a todo looks like when it's not being edited. If you want to
-- edit a todo, simply double click on the todo text, which will change the state
-- so that you are editing that todo.


viewNormalTodo : Int -> String -> Html Msg
viewNormalTodo index todo =
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ span
                [ onDoubleClick (Edit index todo) ]
                [ text todo ]
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

        -- We are just setting the editing property in the model the editing
        -- value that we can use to represent the edit.
        Edit index todoText ->
            { model | editing = Just { index = index, text = todoText } }

        -- We use a let expression to create the new todos. We use List.indexedMap
        -- and change the string of the todo at the editing index to the new string.
        -- We also set the editing property to Nothing because we aren't editing
        -- anymore.
        EditSave index todoText ->
            let
                newTodos =
                    List.indexedMap
                        (\i todo ->
                            if i == index then
                                todoText

                            else
                                todo
                        )
                        model.todos
            in
            { model | editing = Nothing, todos = newTodos }



-- I set the todos property of the model to the list
-- [ "Laundry", "Dishes" ] in the beginning. The editing property is set to
-- Nothing in the beginning since we aren't editing anything in the beginning.


main : Program () Model Msg
main =
    sandbox
        { init =
            { text = ""
            , todos = [ "Laundry", "Dishes" ]
            , editing = Nothing
            }
        , view = view
        , update = update
        }


{-
Exercises to proceed to # 19

What do we need to do?
   Right now we are using the Browser.sandbox method. We now need to change this to use
   the Browser.element method: https://package.elm-lang.org/packages/elm/browser/latest/Browser#element
	

-}



