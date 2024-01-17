# Swatch

Use any VSCode theme in Roblox Studio.

## Installation

- Download from the Roblox Marketplace

## Development

Install prerequisites:
- [Visual Studio Code](https://code.visualstudio.com/) and the following extensions:
  - [Selene](https://marketplace.visualstudio.com/items?itemName=Kampfkarren.selene-vscode)
  - [StyLua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua)
  - [Luau LSP](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.luau-lsp)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Foreman](https://github.com/Roblox/foreman/)
- [Just](https://github.com/casey/just)

Install tools and packages:
```sh
just init
```

Start the server:
```sh
just serve
```

Edit [`plugin/src/constants.lua`](https://github.com/vocksel/vscode-theme-importer-lua/blob/main/plugin/src/constants.lua) and set `SERVER_URL` to `http://localhost:8080`.

Build the plugin:
```sh
just build-watch
```
