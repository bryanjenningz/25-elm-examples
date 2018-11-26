module Main exposing (main)

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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateText newText ->
            ( { model | text = newText }, Cmd.none )

        AddTodo ->
            ( { model | text = "", todos = model.todos ++ [ model.text ] }
            , Cmd.none
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
            ( { model | todos = newTodos }, Cmd.none )

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
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : () -> ( Model, Cmd Msg )
init flags =
    -- This is the short-hand version of what we had before.
    -- Before we had the model initially as the value:
    --   { text = "", todos = [ "Laundry", "Dishes" ], editing = Nothing }
    -- We can also represent this value as this:
    --   Model "" [ "Laundry", "Dishes" ] Nothing
    -- Whenever we make a type alias that's a record, like Model, we
    -- can use Model as a constructor function that returns a Model record.
    -- Since we defined the Model type alias like this:
    -- type alias Model =
    --    { text : String
    --    , todos : List String
    --    , editing : Maybe TodoEdit
    --    }
    -- (Model "" [ "Laundry", "Dishes" ] Nothing) will make the first
    -- argument the text property since that is first in the type alias
    -- declaration. The second argument will be the todos property, and
    -- the third argument will be the editing property.
    ( Model "" [ "Laundry", "Dishes" ] Nothing
    , Cmd.none
    )


main : Program () Model Msg
main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
