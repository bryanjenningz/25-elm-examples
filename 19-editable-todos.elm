module Main exposing (main)

-- We're exposing element now instead of sandbox.
-- This will allow us to do side effects with commands and subscriptions.
-- I'll explain more about commands and subscriptions later, but for now
-- just think of them as the 2 only ways to do side effects in Elm.
-- Having side effects be really controlled like this is really nice for
-- large projects because side effects can only happen in 2 locations, so
-- it makes programs easier to understand.

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



-- We're using element now instead of sandbox, so our update function is
-- slightly different.
-- The update function is mostly the same as before but now instead of just
-- returning the model, we now return a tuple containing the new model value
-- and a command which can perform side effects.
-- We don't need to do any side effects, so we've just added Cmd.none as the
-- command for each returning value of the case expression.
-- Since Elm is a pure functional programming language, the only way you can
-- perform side effects is by using commands and subscriptions. You'll see
-- how they work later. Just think of commands as a way of asking for some
-- side effect to happen and think of subscriptions as a way of listening or
-- subscribing to the result of some side effect.
-- Commands get returned from the update function and the resulting values
-- produced from subscriptions get passed as a message to the update function.


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



-- We don't need subscriptions, so we're just going to have the subscription
-- function return Sub.none, which indicates we have no subscriptions.
-- I'll explain subscriptions more in the future when we use them, so don't
-- worry about them right now.


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : () -> ( Model, Cmd Msg )
init flags =
    ( { text = ""
      , todos = [ "Laundry", "Dishes" ]
      , editing = Nothing
      }
    , Cmd.none
    )


main : Program () Model Msg
main =
    -- We are now using element instead of sandbox, which takes
    -- a record with the properties: init, view, update, and subscriptions.
    -- The init property is similar to the init property in sandbox
    -- except that it takes a function that takes in flags and return a tuple of
    --  type ( Model, Cmd Msg ). The Cmd Msg is useful for if you want to
    -- perform any side effects in the beginning of the program. You usually
    -- don't need to perform any side effects, so you just put the value Cmd.none
    -- as the command value whenever you don't need to do any commands.
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- How to get to Exercise 20:
-- change the init function to make use of the model constructor.
-- HINT: follow these instructions:
    -- The model right now has this as the value:
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
    -- Go ahead and make that change!
