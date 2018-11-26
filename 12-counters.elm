module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- We've added a (Remove Int) value to our Msg union type.
-- The (Remove Int) value will be represent removing a counter at the
-- specified index.


type Msg
    = Increment Int
    | Decrement Int
    | Remove Int
    | AddCount


type alias Model =
    List Int


viewCount : Int -> Int -> Html Msg
viewCount index count =
    div [ class "mb-2" ]
        [ text (String.fromInt count)
        , button
            [ class "btn btn-primary ml-2", onClick (Increment index) ]
            [ text "+" ]
        , button
            [ class "btn btn-primary ml-2", onClick (Decrement index) ]
            [ text "-" ]

        -- We've added a button which will trigger the (Remove Int) message when
        -- it's clicked.
        , button
            [ class "btn btn-primary ml-2", onClick (Remove index) ]
            [ text "X" ]
        ]


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ div [ class "mb-2" ]
            [ button
                [ class "btn btn-primary", onClick AddCount ]
                [ text "Add Count" ]
            ]
        , div [] (List.indexedMap viewCount model)
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment index ->
            List.indexedMap
                (\i count ->
                    if i == index then
                        count + 1

                    else
                        count
                )
                model

        Decrement index ->
            List.indexedMap
                (\i count ->
                    if i == index then
                        count - 1

                    else
                        count
                )
                model

        -- We've added this clause to our case expression that handles the
        -- (Remove Int) message.
        Remove index ->
            -- This is a let expression. Let expressions allow us to create
            -- temporary values that we can use to make our code more readable.
            let
                -- We're using List.take to get the values in the list that are
                -- before the index in the list.
                -- The List.take function will take the first n elements from
                -- the list that it gets passed.
                -- For example:
                -- List.take 2 [1, 3, 5, 4] == [1, 3]
                -- List.take 1 [3, 2, 1] == [3]
                -- List.take 0 [5, 6, 7] == []
                -- Since we want to get all the values in the list that are
                -- before the index, we can write List.take index model
                before =
                    List.take index model

                -- We're using List.drop to get the values in the list that are
                -- after the index in the list.
                -- The List.drop function will drop the first n elements from
                -- the list that it gets passed.
                -- For example:
                -- List.drop 2 [1, 3, 5, 4] == [5, 4]
                -- List.drop 1 [3, 2, 1] == [2, 1]
                -- List.drop 0 [5, 6, 7] == [5, 6, 7]
                -- Since we want to get all the values after the index, we can
                -- drop the first (index + 1) by writing List.drop (index + 1) model.
                after =
                    List.drop (index + 1) model
            in
            -- This is the expression that gets returned in the let expression.
            -- Since we have the list of values before the removed index and
            -- the list of values after the removed index, we can concatenate
            -- them together and that will be the new value that we use as
            -- our model.
            before ++ after

        AddCount ->
            model ++ [ 0 ]


main : Program () Model Msg
main =
    sandbox
        { init = [ 0, 0 ]
        , view = view
        , update = update
        }
