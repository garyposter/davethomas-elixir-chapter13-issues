# Issues

This is a variation of the CLI app built in chapter 13 of Dave Thomas'
[Programming Elixir](https://pragprog.com/book/elixir/programming-elixir).

Errors are my own, and I'm just starting out in Elixir, so don't take this for
anything more than what it is: a way for me to remember what I did for Baby's
First Elixir Project.

## Notes

These are cheatsheet-style notes for my next project, based on what the author
taught for this one.

### Starting off

```bash
$ mix new PROJECT_NAME
$ cd PROJECT_NAME
$ git init
$ git add .
$ git commit -m "Initial commit" # or whatever
```

### Find a library

* Maybe it's [a built-in from
  Elixir](http://elixir-lang.org/docs.html)?
* Maybe it's [a built-in from Erlang](http://erlang.org/doc/)?
* Maybe it's in [hex.pm](https://hex.pm), the Erlang/Elixir
  package manager?
* Try a web search!

### Add a library

* In `mix.exs`, add a new item to the project `deps`, usually
  in a private function named `deps`.  As of this writing, the
  `mix.exs` file has good instructions on the syntax for adding
  a dependency, but in the common case you will simply add a
  hex.pm dependency (e.g. `{:httpoison, "~> 0.8"}`).
* Run `mix deps.get` in the shell to download the dependencies.

### Run a function or an in-project interactive prompt

Either **run it directly**...

```bash
$ mix run -e STRING
```

...(e.g. `mix run -e
'Issues.CLI.run(["-h"])`); or **start an interactive prompt**:

```bash
$ iex -S mix
```

### Config values

I'm not sure how to reconcile this with Heroku, yet, and I don't fully
understand the associated dev/stage/prod story yet, but it's apparently
idiomatic to put config values in `config/config.exs`.  See instructions in the
generated file.

### To create an escript binary

In `mix.exs`, in the `project` function's data, add an `escript` key that,
directly or indirectly, specifies a `main_module` (e.g. `[main_module:
Issues.CLI]`) and make sure that the specified module includes a `main` function
that takes an argv list.  Finally, run `mix escript.build` to create the binary.

### To add logging

In `mix.exs`, in the `application` function's `applications` list, add
`:logger`.  For the four levels of severity (`debug`, `info`, `warn`, and
`error`), you can control the level compiled in your code in `config/config.exs`
with a line like this: `config :logger, compile_time_purge_level: :info`.  You
can reduce the level of logging further at runtime by calling
`Logger.configure`.

You log with a string (e.g. `Logger.warn "The #{component} can't take much more
o' this!"`) or a zero-arity function returning a string, if calculating the
string is expensive and you don't want to have to pay the price at runtime if
the runtime-configured log level doesn't include it.

### Test tricks

To **capture IO in tests**, `import​ ExUnit.CaptureIO` and then use `result =
capture_io FUNCTION`.

To **create a doctest** within `@doc` metadata, indent at least four spaces and prefix the line with `iex> `.  Lines can be continued with `...> `.

```markdown
## Example

    iex> frobnitz(
    ...>   "caerphilly",
    ...>   "wensleydale")
    42
```
