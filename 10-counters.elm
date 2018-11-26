module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- We added an AddCount value as our Msg type, which we'll use to indicate
-- that we want to add a counter to our list of counters.


type Msg
    = Increment Int
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
        ]


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ div [ class "mb-2" ]
            -- We added a new button that we can click and it will make it
            -- so that we add a new counter to the list.
            -- When the user clicks on the "Add Count" button, it triggers
            -- an onClick event, which will pass the AddCount value into the
            -- update function. The update function will return a list which
            -- has an extra integer value at the end of the list, which
            -- represents the new counter.
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

        -- When the message type is AddCount, we will append a 0 to the end of
        -- the list. We can get this effect by concatenating 2 lists together.
        -- The ++ operator is the concatenate operator, which takes 2 lists and
        -- puts them together.
        -- For example: [ 1, 2 ] ++ [ 0 ] will be [ 1, 2, 0 ]
        AddCount ->
            model ++ [ 0 ]


main : Program () Model Msg
main =
    sandbox
        { init = [ 0, 0 ]
        , view = view
        , update = update
        }
