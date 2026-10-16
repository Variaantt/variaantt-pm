# Variaantt's Private Messages

A lightweight private messaging system for FiveM. Players send private messages to each other by server ID with `/pm`, and the receiver can answer the last person who wrote to them with `/r`. Messages appear as modern on-screen notifications with an icon, a sound and a progress bar.

<!-- Add a screenshot or a short GIF here, for example: ![Preview](preview.png) -->

## Features

- `/pm <id> <message>` sends a private message to the player with that server ID
- `/r <message>` answers the last player who sent you a message
- Notification UI (NUI) in the top-right corner, with a different icon and bar color for each type: sent confirmation, received message, answer and error
- Display time that grows with the length of the message (minimum and maximum are configurable)
- Sound played when a message or an answer arrives
- Input checks on the server: valid ID, connected player, non-empty message
- Message text is inserted with `textContent`, so players cannot inject HTML into other players' screens

## Requirements

- A FiveM server (any recent artifact)
- Lua 5.4 (enabled in the manifest with `lua54 'yes'`)

No other resources or frameworks are required.

## Installation

1. Download or clone this repository.
2. Put the folder inside your server's `resources` directory.
3. Add the resource to your `server.cfg`:

   ```cfg
   ensure variaantt-pm
   ```

   Use the same name as the folder.
4. Restart the server, or run `refresh` and `ensure variaantt-pm` from the console.

## Usage

| Command | Who can use it | Description |
|---|---|---|
| `/pm <id> <message>` | Everyone (see the warning below) | Sends a private message to the player with the given server ID |
| `/r <message>` | Everyone | Answers the last player who sent you a message |

Examples:

```
/pm 12 Hello, can you come to the garage?
/r Sure, I'm on my way
```

You can see a player's ID in the scoreboard or in the server player list.

## Important: there is no permission check

By default **anyone** can use `/pm`. This resource does not include an admin check on purpose, so it can be adapted to any server setup.

If you want only admins to send messages, add a check at the very beginning of the `/pm` command in `server.lua`. For example, with ACE permissions you can use `IsPlayerAceAllowed(source, "your.permission")` and return early if it is false, then grant the permission in `server.cfg` with `add_ace` and `add_principal`. If you use a framework (ESX, QBCore, ...), use its own permission or group system instead.

## How it works

```
/pm (server.lua)  ->  TriggerClientEvent  ->  client.lua  ->  SendNUIMessage  ->  scripts.js (notification)
```

1. The server registers the commands, validates the input and keeps a table with the last sender of each player (used by `/r`).
2. The server sends the `sendMessage` event to the right client with a type and a text.
3. The client receives the event and forwards it to the NUI page.
4. The page builds the notification, plays the sound and removes it when its time is over.

Notification types sent by the server:

| Type | Used for |
|---|---|
| `msg` | A private message you received |
| `answer` | An answer to a message you sent |
| `success` | Confirmation shown to the sender |
| `error` | Invalid ID, empty message, nobody to answer, ... |

## Configuration

The values are constants at the top of the script in the `html` folder:

| Constant | Default | Meaning |
|---|---|---|
| `BASE` | `2000` | Base display time (ms) |
| `PER_CHAR` | `50` | Extra time (ms) for each character of the message |
| `MIN` | `3000` | Minimum display time (ms) |
| `MAX` | `12000` | Maximum display time (ms) |
| `audio.volume` | `0.2` | Sound volume, from `0` to `1` |

To change colors, size or position of the notifications, edit the CSS file.

## Project structure

```
variaantt-pm/
├── fxmanifest.lua
├── client.lua
├── server.lua
└── html/
    ├── index.html
    ├── style.css
    ├── scripts.js
    ├── img/
    │   ├── success.png
    │   ├── msg.png
    │   └── failed.png
    └── audio/
        └── notify.mp3
```

Every file in `html` (including images and audio) must be listed in the `files` section of `fxmanifest.lua`, otherwise FiveM will not serve it to the client.

## Known limitations

- Sending a message to yourself is allowed (useful for testing).
- The ID is not checked to be an integer.
- Text formatting (bold, italic, ...) is not supported.
- The last sender is stored in memory, so the `/r` history is lost when the resource restarts.

## Credits

Made by **Variaantt**.

### How this project was made

- The Lua and JavaScript code was written entirely by hand.
- **Claude** (Anthropic) was used as an assistant, to explain concepts and review the code, and it also helped with part of the CSS.
- **ChatGPT** (OpenAI) generated the icons, defined the UI design and wrote the CSS.
- The notification sound was taken from a free sound website (Mixkit Sound Effects Free License).

## License

This project is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for details.