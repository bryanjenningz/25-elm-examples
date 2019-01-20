port module Main exposing (main)

-- We need some additional imports from Browser and Browser.Navigation packages.
-- We're going to use functionality from them to keep track of the URL and display
-- the appropriate todos for that URL.
-- For example, "/#incomplete" will show the incomplete todos and
-- "/#completed" will show the completed todos. All other URLs will
-- show all of the todos.

import Browser exposing (Document, UrlRequest(..), application)
import Browser.Navigation exposing (Key)
import Html exposing (..)
import Html.Attributes exposing (autofocus, checked, class, href, placeholder, style, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Random
import Url exposing (Url)



-- We add two new messages:
-- LinkClicked and ChangeUrl which are sent to our application by
-- Browser.application every time when user clicks a link on a page or changes
-- the URL in browser's navigation bar.


type Msg
    = UpdateText String
    | GenerateTodoId
    | AddTodo Int
    | RemoveTodo Int
    | Edit Int String
    | EditSave Int String
    | ToggleTodo Int
    | SetFilter Filter
    | LinkClicked UrlRequest
    | ChangeUrl Url


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

    -- We need to store the Browser.Navigation.Key in our model to be able to
    -- call browser navigation functions from Browser.Navigation module.
    -- The key gets passed to us on application initialization, where we store
    -- it in our model.
    -- Each function from Browser.Navigation module which manipulates browser
    -- URL requires us to pass in this Key as a parameter.
    -- This was a design decision made by the core developers
    -- or Elm to prevent people from calling browser navigation functions outside
    -- Browser.application (e.g. from less featureful applications like those
    -- created by Browser.element), which could lead to a lot of insidious bugs.
    , navigationKey : Key
    }



-- view function for the Browser.application requires us to return a value of
-- type `Document Msg`. This is just a record containing
-- 1. title String, which is used as a page title in the browser toolbar
-- 2. body, which is a list of Html elements that will be children of the page's
-- body element.


view : Model -> Document Msg
view model =
    { title = "Navigation TODOs"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
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
            , style "cursor" "pointer"
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
                , style "text-decoration"
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

        -- Whenever user clicks a link on the page, the Elm runtime generates
        -- this message for us and gives us the possibility to react.
        -- See the docs in the elm/browser package to understand the difference
        -- between Internal and External URL:
        -- https://package.elm-lang.org/packages/elm/browser/latest/Browser#UrlRequest
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                      -- When user clicks a link in our app (like "Complete")
                      -- we ask the browser to make the new url part of browsing history
                      -- WITHOUT reloading the page (i.e. without triggering http
                      -- request to load a new page from the server).
                    , Browser.Navigation.pushUrl model.navigationKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        -- Whenever the URL changes, the current URL gets passed to
        -- ChangeUrl, which gets passed into the update function.
        -- We pass the url into urlToFilter, which takes the
        -- current location and returns the current filter.
        ChangeUrl url ->
            ( { model | filter = urlToFilter url }, Cmd.none )



-- We only care about url.fragment for determining which filter is set.
-- If the fragment is "incomplete", we want our filter to be Incomplete, so
-- that the todos that are incomplete are shown.
-- We want "complete" to show the completed todos.
-- The clause _ -> catches all other strings, which means that all other
-- URL hashes will show all of the todos.


urlToFilter : Url -> Filter
urlToFilter url =
    case url.fragment of
        Nothing ->
            All

        Just hash ->
            case String.toLower hash of
                "incomplete" ->
                    Incomplete

                "completed" ->
                    Completed

                _ ->
                    All


port saveTodos : List Todo -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- We're now using Browser.application, whose init function requires two additional
-- arguments:
-- 1. Url  - This will be passed to us by Elm runtime when the application is
-- initialized.
-- In our app we're using the URL to parse the currently active filter from
-- the URL's fragment (the part of URL following the '#' character).
-- We use (urlToFilter url) which returns the filter that we will use for that URL.
--  So if the page's URL is initially "/#completed", then (urlToFilter url) will
-- return Completed as the filter, so the filter value will be Completed,
-- which will lead to the completed todos to be shown.
-- 2. Key is the navigation key that we need to save into our model. We need it
-- to be able to control the browser's page loading functionality
-- (see LinkClicked branch of the update function for how the Key is used).


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url navigationKey =
    ( { text = ""
      , todos = flags.todos
      , editing = Nothing
      , filter = urlToFilter url
      , navigationKey = navigationKey
      }
    , Cmd.none
    )


type alias Flags =
    { todos : List Todo }



{-
   We're using Browser.application instead of Browser.element, which extends the
   latter in 3 important ways:

   1. init gets two additional parameters:
     - the current Url from the browsers navigation bar.
     This allows you to show different things depending on the Url.
     - the navigation Key, which you can save in your model and use it later to be able
     add items to manipulate browser's navigation history

   2. When someone clicks a link, like <a href="/home">Home</a>, it is intercepted
   as a UrlRequest. So instead of loading new HTML, onUrlRequest creates a message
   for your update where you can decide exactly what to do next.

   3. When the URL changes, the new Url is sent to onUrlChange.
   The resulting message goes to update where you can decide how to show the new page.
-}


main : Program Flags Model Msg
main =
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = ChangeUrl
        }
