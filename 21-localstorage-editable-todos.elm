-- We added "port" in from of the module declaration, which indicates that we
-- are using ports in this module. Ports are a way of communicating to JavaScript.
-- We're using ports to save our model state in localStorage.


port module Main exposing (main)

import Browser exposing (element)
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, placeholder, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)


type Msg
    = UpdateText String
    | AddTodo
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String


type alias TodoEdit =
    { index : Int
    , text : String
    }


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
        , div [] (List.indexedMap (viewTodo model.editing) model.todos)
        ]


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



-- There are some clauses of the case statement that return a command now.
-- The command carries the current todos state, which gets sent to JavaScript
-- via ports. The JavaScript code is subscribed to the saveTodos port, which
-- passes the todos into a callback that saves the todos to localStorage in
-- JavaScript.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateText newText ->
            ( { model | text = newText }, Cmd.none )

        AddTodo ->
            let
                newTodos =
                    model.todos ++ [ model.text ]
            in
            ( { model | text = "", todos = newTodos }
            , saveTodos newTodos
            )

        RemoveTodo index ->
            let
                beforeTodos =
                    List.take index model.todos

                afterTodos =
                    List.drop (index + 1) model.todos

                newTodos =
                    beforeTodos ++ afterTodos
            in
            ( { model | todos = newTodos }, saveTodos newTodos )

        Edit index todoText ->
            ( { model | editing = Just { index = index, text = todoText } }
            , Cmd.none
            )

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
            ( { model | editing = Nothing, todos = newTodos }
            , saveTodos newTodos
            )



-- This is the port declaration that we're going to use to save our todos
-- to localStorage.


port saveTodos : List String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- The init value is now a function that takes in the flags as an argument
-- and returns a tuple containing the initial model and a command. We initially
-- set the todos value to the todos that come from the flag. The todos that
-- came with the flag are the todos that were loaded from localStorage and passed
-- into Elm.


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model "" flags.todos Nothing
    , Cmd.none
    )



-- We're going to use flags to load the todos from localStorage at the start of
-- the web app. Flags are the value passed in from JavaScript in the very
-- beginning. Since we want the todos from localStorage, we're going to make the
-- Flags type be a record that has a todos property, which is a list of strings
-- that represents the todos that were loaded from localStorage and passed into
-- Elm as flags.


type alias Flags =
    { todos : List String }



-- The type declaration change from (Program () Model Msg) because now we're
-- using flags to get the todos from JavaScript in the beginning of the program.


main : Program Flags Model Msg
main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
