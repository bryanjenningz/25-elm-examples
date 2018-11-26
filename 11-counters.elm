module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- We've added the (Decrement Int) value to the Msg union type.
-- (Decrement Int) will work in a similar way that (Increment Int) works
-- except it will decrement the counter at the specified index instead of
-- incrementing it.


type Msg
    = Increment Int
    | Decrement Int
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

        -- We added a button that will trigger pass a (Decrement Int) message
        -- to the update function when it's clicked.
        , button
            [ class "btn btn-primary ml-2", onClick (Decrement index) ]
            [ text "-" ]
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

        -- We added an expression that handles the (Decrement Int) message value,
        -- which decrements the counter at the index that we care about.
        Decrement index ->
            List.indexedMap
                (\i count ->
                    if i == index then
                        count - 1

                    else
                        count
                )
                model

        AddCount ->
            model ++ [ 0 ]


main : Program () Model Msg
main =
    sandbox
        { init = [ 0, 0 ]
        , view = view
        , update = update
        }
