port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, autofocus, placeholder, style, type_, checked)
import Html.Events exposing (onInput, onClick, onSubmit, onDoubleClick)


type Msg
    = UpdateText String
    | AddTodo
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String
    | ToggleTodo Int
    | SetFilter Filter


type Filter
    = All
    | Incomplete
    | Completed


type alias TodoEdit =
    { index : Int
    , text : String
    }


type alias Todo =
    { text : String
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
        , viewFilters model.filter
        , div [] <|
            List.indexedMap
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
            , style [ ( "cursor", "pointer" ) ]
            ]
            [ text filterText ]


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
            [ input
                [ onClick (ToggleTodo index)
                , type_ "checkbox"
                , checked todo.completed
                , class "mr-3"
                ]
                []
            , span
                [ onDoubleClick (Edit index todo.text)
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
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
