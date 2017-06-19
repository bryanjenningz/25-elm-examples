module Main exposing (..)

import Html exposing (Html, text, div, beginnerProgram, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type Msg
    = Increment Int
    | Decrement Int
    | AddCount


type alias Model =
    List Int


viewCount : Int -> Int -> Html Msg
viewCount index count =
    div [ class "mb-2" ]
        [ text (toString count)
        , button
            [ class "btn btn-primary ml-2", onClick (Increment index) ]
            [ text "+" ]
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


main : Program Never Model Msg
main =
    beginnerProgram
        { model = [ 0, 0 ]
        , view = view
        , update = update
        }
