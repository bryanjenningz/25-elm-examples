port module Main exposing (main)

-- Importing the Random module because we're going to use it to generate
-- a random id so that we can uniquely identify each todo.

import Browser exposing (element)
import Html exposing (..)
import Html.Attributes exposing (autofocus, checked, class, placeholder, style, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Random



-- Added GenerateTodoId message, which we're going to use to generate a
-- random id for a newly created todo.
-- AddTodo was changed to (AddTodo Int) because it now takes the integer
-- id that was randomly generated and uses that to add the new todo.


type Msg
    = UpdateText String
    | GenerateTodoId
    | AddTodo Int
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String
    | ToggleTodo Int
    | SetFilter Filter


type Filter
    = All
    | Incomplete
    | Completed



-- Before TodoEdit had an index and a text field, now we're going to be
-- using the todo's id to identify which todo we're editing, so I
-- switched the field name from index to id.


type alias TodoEdit =
    { id : Int
    , text : String
    }



-- Added an id field, which will hold each todo's randomly generated id.


type alias Todo =
    { id : Int
    , text : String
    , completed : Bool
    }


type alias Model =
    { text : String
    , todos : List Todo
    , editing : Maybe TodoEdit
    , filter : Filter
    }


view : Model -> Html Msg
view model =
    div [ class "col-12 col-sm-6 offset-sm-3" ]
        -- GenerateTodoId is now the message that gets passed into
        -- the update function as the message when the form submits.
        [ form [ class "row", onSubmit GenerateTodoId ]
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
        , viewFilters model.filter
        , div [] <|
            -- We use List.map now instead of List.indexedMap, since we
            -- are using the id and not the index to edit and remove todos.
            List.map
                (viewTodo model.editing)
                (filterTodos model.filter model.todos)
        ]


filterTodos : Filter -> List Todo -> List Todo
filterTodos filter todos =
    case filter of
        All ->
            todos

        Incomplete ->
            List.filter (\t -> not t.completed) todos

        Completed ->
            List.filter (\t -> t.completed) todos


viewFilters : Filter -> Html Msg
viewFilters filter =
    div []
        [ viewFilter All (filter == All) "All"
        , viewFilter Incomplete (filter == Incomplete) "Incomplete"
        , viewFilter Completed (filter == Completed) "Completed"
        ]


viewFilter : Filter -> Bool -> String -> Html Msg
viewFilter filter isFilter filterText =
    if isFilter then
        span [ class "mr-3" ] [ text filterText ]

    else
        span
            [ class "text-primary mr-3"
            , onClick (SetFilter filter)
            , style "cursor" "pointer"
            ]
            [ text filterText ]



-- viewTodo now has one less argument because it doesn't need
-- to have the index passed in anymore since it uses the id
-- for editing and removing each todo. It also doesn't pass
-- the index into viewEditTodo and viewNormalTodo anymore.


viewTodo : Maybe TodoEdit -> Todo -> Html Msg
viewTodo editing todo =
    case editing of
        Just todoEdit ->
            if todoEdit.id == todo.id then
                viewEditTodo todoEdit

            else
                viewNormalTodo todo

        Nothing ->
            viewNormalTodo todo



-- viewEditTodo has one less argument because it doesn't need the index
-- for editing, it uses the todo's id to identify the todo that is being edited.
-- It passes in todoEdit.id into Edit and EditSave now instead of the index.


viewEditTodo : TodoEdit -> Html Msg
viewEditTodo todoEdit =
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ form [ onSubmit (EditSave todoEdit.id todoEdit.text) ]
                [ input
                    [ onInput (Edit todoEdit.id)
                    , class "form-control"
                    , value todoEdit.text
                    ]
                    []
                ]
            ]
        ]



-- viewNormalTodo has one less argument because it doesn't need the index.
-- It now passes todo.id into ToggleTodo, Edit, and RemoveTodo instead of the index.


viewNormalTodo : Todo -> Html Msg
viewNormalTodo todo =
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ input
                [ onClick (ToggleTodo todo.id)
                , type_ "checkbox"
                , checked todo.completed
                , class "mr-3"
                ]
                []
            , span
                [ onDoubleClick (Edit todo.id todo.text)
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
                [ onClick (RemoveTodo todo.id)
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

        -- When the form to add a new todo submits, it now passes in
        -- GenerateTodoId, which will generate a random integer id,
        -- then the result will be passed into AddTodo which now accepts
        -- an integer.
        -- I'm going to explain each part of this:
        --   Random.generate AddTodo (Random.int Random.minInt Random.maxInt)
        -- Random.int is a function that takes 2 Int arguments and returns
        -- a (Generate Int) type. Random.minInt is the minimum integer value
        -- that a 32-bit integer can be. Random.maxInt is the maximum integer
        -- value that a 32-bit integer can be.
        -- So (Random.int Random.minInt Random.maxInt) is a Generator Int type.
        -- Random.generate is a function that takes a function that accepts an
        -- Int and returns a Msg as the first argument and a Generator Int as
        -- the second argument, then it will randomly generate an integer
        -- between Random.minInt and Random.maxInt, then it will pass that
        -- integer to AddTodo, which will get passed into the update function.
        GenerateTodoId ->
            ( model
            , Random.generate AddTodo (Random.int Random.minInt Random.maxInt)
            )

        -- So now after the random id is generated, it gets passed into AddTodo
        -- which gets passed into the update function. We take the id and current
        -- model.text value to create the new todo and then we append the new
        -- todo to the end of model.todos.
        AddTodo todoId ->
            let
                newTodos =
                    model.todos ++ [ Todo todoId model.text False ]
            in
            ( { model | text = "", todos = newTodos }
            , saveTodos newTodos
            )

        -- Since we get passed the id, we can just use List.filter to
        -- keep all the todos that don't have the same id as the one
        -- we are removing.
        RemoveTodo todoId ->
            let
                newTodos =
                    List.filter (\todo -> todo.id /= todoId) model.todos
            in
            ( { model | todos = newTodos }, saveTodos newTodos )

        -- We use id to track the edited todo instead of the index.
        Edit todoId todoText ->
            ( { model | editing = Just { id = todoId, text = todoText } }
            , Cmd.none
            )

        -- We are now saving the todo, so if the todo's id is the id that we
        -- were editing, then we change the text of that todo to the edit text.
        -- If its id isn't the same as the edit todo's id, we keep it the same
        -- because it wasn't the todo that we were editing.
        EditSave todoId todoText ->
            let
                newTodos =
                    List.map
                        (\todo ->
                            if todo.id == todoId then
                                { todo | text = todoText }

                            else
                                todo
                        )
                        model.todos
            in
            ( { model | editing = Nothing, todos = newTodos }
            , saveTodos newTodos
            )

        -- We map over the todos and change the completed field of
        -- the todo that has the id that we chose to toggle.
        ToggleTodo todoId ->
            let
                newTodos =
                    List.map
                        (\todo ->
                            if todo.id == todoId then
                                { todo | completed = not todo.completed }

                            else
                                todo
                        )
                        model.todos
            in
            ( { model | todos = newTodos }, saveTodos newTodos )

        SetFilter filter ->
            ( { model | filter = filter }, Cmd.none )


port saveTodos : List Todo -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model "" flags.todos Nothing All
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
