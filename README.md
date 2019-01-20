# 25 Elm Examples

These 25 Elm examples will take you from building a static view all the way to building an interactive web app with routing.

## Links to the examples using Ellie

- [01-hello-world.elm](https://ellie-app.com/3Z93zn5Qy3Da1)
- [02-hello-world.elm](https://ellie-app.com/3Z93XBfHxcxa1)
- [03-hello-world.elm](https://ellie-app.com/3Z94mwpfHN7a1)
- [04-hello-world.elm](https://ellie-app.com/3Z95c4y6L9ha1)
- [05-counter.elm](https://ellie-app.com/3Z95CNBn5Jha1)
- [06-counter.elm](https://ellie-app.com/3Z97wqKsdn5a1)
- [07-counter.elm](https://ellie-app.com/3Z97Y4VvSfRa1)
- [08-counter.elm](https://ellie-app.com/3Z989cTkqPja1)
- [09-counters.elm](https://ellie-app.com/3Z98PYxYvC4a1)
- [10-counters.elm](https://ellie-app.com/3Z998Dq7PD5a1)
- [11-counters.elm](https://ellie-app.com/3Z99qnMwbQra1)
- [12-counters.elm](https://ellie-app.com/3Z99K3tpYbKa1)
- [13-input-box.elm](https://ellie-app.com/3Z99YBq3jM8a1)
- [14-todos.elm](https://ellie-app.com/3Z9bnpxFvffa1)
- [15-todos.elm](https://ellie-app.com/3Z9bCnDPRv8a1)
- [16-todos.elm](https://ellie-app.com/3Z9bXz3RsyQa1)
- [17-todos.elm](https://ellie-app.com/3Z9cf8ZrCpta1)
- [18-editable-todos.elm](https://ellie-app.com/3Z9cDJ3N9g4a1)
- [19-editable-todos.elm](https://ellie-app.com/3Z9d3dXRdPxa1)
- [20-editable-todos.elm](https://ellie-app.com/3Z9dhJHkXg6a1)
- [21-localstorage-editable-todos.elm](https://ellie-app.com/3Z9dKFRMyNDa1)
- [22-localstorage-editable-todos.elm](https://ellie-app.com/3Z9fg9YtbV4a1)
- [23-filter-todos.elm](https://ellie-app.com/3Z9fFVqF9Pra1)
- [24-filter-todos.elm](https://ellie-app.com/3Z9gnSZKYPTa1)
- [25-navigation-todos.elm](https://ellie-app.com/3wR7QgwzngSa1/25)

## How to run and view examples 21-25 on your computer
You can use the Ellie links for examples 21-25, but if you want to run it locally,
you can copy/paste the following commands which will clone the Github repo,
then compile example 21 to a JavaScript file called elm.js,
then you will open the HTML for example 21 in your default browser.

```bash
git clone https://github.com/bryanjenningz/25-elm-examples.git
cd 25-elm-examples
elm make 21-localstorage-editable-todos.elm --output elm.js
elm reactor
# The elm reactor command will server your files to http://localhost:8000,
# so go to http://localhost:8000 in your browser and select the HTML file.
```

The above code will compile and open example 21 in your default browser.
To compile and view examples 22 through 25 locally, you do the same process of
compiling the Elm file you want to the elm.js JavaScript file,
then running `elm reactor` and selecting the HTML file in your browser at
http://localhost:8000.

## Other Free Resources

  - [Official Elm Guide](https://guide.elm-lang.org/)
  - [Ellie App](https://ellie-app.com/)
  - [Elm subreddit](https://www.reddit.com/r/elm/)
  - [Elm Slack channel](https://elmlang.slack.com/)
  - [RealWorld Elm example app](https://github.com/rtfeldman/elm-spa-example)


These 25 Elm examples were inspired by the [examples](http://elm-lang.org/examples)
on the Elm website and the [official Elm guide](https://guide.elm-lang.org/).
Each example tries to build off of the previous example by adding a small amount
of code so that it's easy to understand and see how you can build stuff in Elm.
If you have any suggestions for more examples that should be added or if anything
is unclear, add an issue or make a pull request.
