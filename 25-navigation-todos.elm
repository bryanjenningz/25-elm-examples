-- TODO: UPGRADE THIS FILE TO ELM 0.19


port module Main exposing (main)

-- Importing the Navigation module because we're going to be using it
-- to keep track of the URL and display the appropriate todos for that
-- URL. For example, "/#incomplete" will show the incomplete todos and
-- "/#completed" will show the completed todos. All other URLs will
-- show all of the todos.

import Html exposing (..)
import Html.Attributes exposing (autofocus, checked, class, href, placeholder, style, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Navigation
import Random



-- UrlChange Navigation.Location is a new message type.
-- Every time the location in the URL changes, UrlChange will
-- get passed the new location record which contains information
-- about the URL.


type Msg
    = UpdateText String
    | GenerateTodoId
    | AddTodo Int
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String
    | ToggleTodo Int
    | SetFilter Filter
    | UrlChange Navigation.Location


type Filter
    = All
    | Incomplete
    | Completed


type alias TodoEdit =
    { id : Int
    , text : String
    }


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
        a
            [ class "text-primary mr-3"

            -- Whenever the user clicks on a filter link, the
            -- hash in the URL changes to the filterText.
            -- So if you refresh the page and your URL is
            -- "/#completed", the completed todos will be visible.
            , href ("#" ++ String.toLower filterText)
            , onClick (SetFilter filter)
            , style [ ( "cursor", "pointer" ) ]
            ]
            [ text filterText ]


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
                    [ ( "text-decoration"
                      , if todo.completed then
                            "line-through"

                        else
                            "none"
                      )
                    ]
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

        GenerateTodoId ->
            ( model
            , Random.generate AddTodo (Random.int Random.minInt Random.maxInt)
            )

        AddTodo todoId ->
            let
                newTodos =
                    model.todos ++ [ Todo todoId model.text False ]
            in
            ( { model | text = "", todos = newTodos }
            , saveTodos newTodos
            )

        RemoveTodo todoId ->
            let
                newTodos =
                    List.filter (\todo -> todo.id /= todoId) model.todos
            in
            ( { model | todos = newTodos }, saveTodos newTodos )

        Edit todoId todoText ->
            ( { model | editing = Just { id = todoId, text = todoText } }
            , Cmd.none
            )

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

        -- Whenever the URL changes, the current location gets passed to
        -- UrlChange, which gets passed into the update function.
        -- We pass the location into locationToFilter, which takes the
        -- current location and returns the current filter.
        UrlChange location ->
            ( { model | filter = locationToFilter location }, Cmd.none )



-- We only care about location.hash for determining which filter is set.
-- If the hash is "#incomplete", we want our filter to be Incomplete, so
-- that the todos that are incomplete are shown.
-- We want "#complete" to show the completed todos.
-- The clause _ -> catches all other strings, which means that all other
-- URL hashes will show all of the todos.


locationToFilter : Navigation.Location -> Filter
locationToFilter location =
    case String.toLower location.hash of
        "#incomplete" ->
            Incomplete

        "#completed" ->
            Completed

        _ ->
            All


port saveTodos : List Todo -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- We're now using Navigation.programWithFlags, which takes an extra argument
-- which is the initial location when the page loads. We want the filter to
-- be set based on the current location, so we use (locationToFilter location)
-- which returns the filter that we will use for that URL. So if the page's
-- URL is initially "/#completed", then (locationToFilter location) will return
-- Completed as the filter, so the filter value will be Completed, which will
-- make it show the completed todos are shown.


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( Model "" flags.todos Nothing (locationToFilter location)
    , Cmd.none
    )


type alias Flags =
    { todos : List Todo }



-- We're using Navigation.programWithFlags instead of Html.programWithFlags,
-- which takes UrlChange and it will pass the location to UrlChange whenever
-- the URL changes and then that will get passed into the update function.


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
