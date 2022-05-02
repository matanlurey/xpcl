# xpcl

An experimental command-line interface for menu-based games or workflow UIs.

## Why menu-based games

In short, because I can. No really, something that always sucks a bunch of time
whenever I have a turn-based game concept but I end up spending way too much
time trying to get the UI to "look good". So, enter `xpcl`, a rapid iteration
tool for menu-based games.

These types of apps are not easy to create, for example, imagine Casino War:

![Code snippet of Casino War](https://user-images.githubusercontent.com/168174/166171412-55ef3d91-3e00-4c0e-a519-df17d3278303.png)

Once you need responses, parsing (for command-line inputs), verification, you
are slowly building a full UI toolkit or have to write your app for a specific
toolkit.

With XPCL, by the time you need to create a "real" UI, you'll have a lot of the
concept out of the way, and probably reusable non-UI code (such as the game
logic, serialization, or anything else). Some games might not even need a "real"
UI and it's possible to extend `xpcl` to get a more "polished" feel.

_This idea is partially inspired by
[Balasamiq Wireframes](https://balsamiq.com/wireframes/) an intentionally
low-fildelity UI wireframing tool._

## Project goals

Or, how can we tell if this project is on track:

- **CLI "spec" implementation**: Run out of the box with a basic CLI runner.
- **High abstraction**: It should not be noticeable you're doing anything but
  creating and responding to menu-like UI structures.
- **Nimble**: It should be easy to quickly iterate, with a great developer
  experience.

Slightly longer term, I'd like to consider writing my own language (i.e. `.xpcl`
) which is domain-specific for this style of simple workflow app or game. It's
unlikely to ever be "good", but it would be fun.

### Examples

Here are a couple of apps or games I want to be able to implement in `example`:

- [ ] War (Card Game)
- [ ] BlackJack (Card Game)
- [ ] Jedi Duel
- [ ] Pong
- [ ] Game of Life
