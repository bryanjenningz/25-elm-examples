port module Main exposing (main)

import Browser exposing (element)
import Html exposing (..)
import Html.Attributes exposing (autofocus, checked, class, placeholder, style, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)


type Msg
    = UpdateText String
    | AddTodo
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String
    | ToggleTodo Int


type alias TodoEdit =
    { index : Int
    , text : String
    }



-- We changed the todos so that they aren't just strings, they now are records
-- with a completed property which represents whether the user has completed
-- that todo.


type alias Todo =
    { text : String
    , completed : Bool
    }



-- The todos property is now List Todo instead of List String.


type alias Model =
    { text : String
    , todos : List Todo
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


viewTodo : Maybe TodoEdit -> Int -> Todo -> Html Msg
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


viewNormalTodo : Int -> Todo -> Html Msg
viewNormalTodo index todo =
    div [ class "card" ]
        [ div [ class "card-block" ]
            -- Added a checkbox that can be clicked to toggle the todo between
            -- being completed or incomplete.
            [ input
                [ onClick (ToggleTodo index)
                , type_ "checkbox"
                , checked todo.completed
                , class "mr-3"
                ]
                []
            , span
                [ onDoubleClick (Edit index todo.text)

                -- Added styling to indicate a todo is completed.
                , style
                    "text-decoration"
                    (if todo.completed then
                        "line-through"

                     else
                        "none"
                    )
                ]
                [ text todo.text ]
            , span
                [ onClick (RemoveTodo index)
                , class "float-right"
                ]
                [ text "✖" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateText newText ->
            ( { model | text = newText }, Cmd.none )

        AddTodo ->
            let
                newTodos =
                    model.todos ++ [ Todo model.text False ]
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
                                { todo | text = todoText }

                            else
                                todo
                        )
                        model.todos
            in
            ( { model | editing = Nothing, todos = newTodos }
            , saveTodos newTodos
            )

        -- Added an extra clause to handle toggling the todo.
        ToggleTodo index ->
            let
                newTodos =
                    List.indexedMap
                        (\i todo ->
                            if i == index then
                                { todo | completed = not todo.completed }

                            else
                                todo
                        )
                        model.todos
            in
            ( { model | todos = newTodos }, saveTodos newTodos )



-- We changed the port type declaration to take a list of Todo records.


port saveTodos : List Todo -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model "" flags.todos Nothing
    , Cmd.none
    )


type alias Flags =
    { todos : List Todo }


main : Program Flags Model Msg
main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
