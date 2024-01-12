#!/usr/bin/env just --justfile

set dotenv-load

project_name := "rbxtheme"
plugins_dir := if os_family() == "unix" {
	"$HOME/Documents/Roblox/Plugins"
} else {
	"$LOCALAPPDATA/Roblox/Plugins"
}
plugin_filename := project_name + ".rbxm"
plugin_source := "plugin/src"
server_source := "server/src"
plugin_output := plugins_dir / plugin_filename
plugin_project := "plugin/tests.project.json"
tmpdir := `mktemp -d`

default:
  @just --list

clean:
	rm -rf {{ plugin_output }}

lint:
	selene {{ plugin_source }}
	stylua --check {{ plugin_source }}

	selene {{ server_source }}
	stylua --check {{ server_source }}

_build target watch:
	mkdir -p {{ parent_directory(plugin_output) }}
	./bin/build.py --target {{ target }} --output {{ plugin_output }} \
		{{ if watch == "true"  { "--watch" } else { "" } }}

init:
	foreman install
	lune --setup
	just wally-install

wally-install:
	wally install
	rojo sourcemap {{ plugin_project }} -o "{{ tmpdir }}/sourcemap.json"
	wally-package-types --sourcemap "{{ tmpdir }}/sourcemap.json" Packages/

build target="prod":
	just _build {{ target }} false

build-watch target="prod":
	just _build {{ target }} true

build-here target="prod" filename=plugin_filename:
	./bin/build.py --target {{ target }} --output {{ filename }}

test: clean
    rojo build {{ plugin_project }} -o {{ tmpdir / "tests.rbxl" }}
    run-in-roblox --place {{ tmpdir / "tests.rbxl" }} --script tests/init.server.lua

serve:
	docker compose up

analyze:
  curl -s -o "{{ tmpdir }}/globalTypes.d.lua" -O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/master/scripts/globalTypes.d.lua

  rojo sourcemap {{ plugin_project }} -o "{{ tmpdir }}/sourcemap.json"

  luau-lsp analyze --sourcemap="{{ tmpdir }}/sourcemap.json" --defs="{{ tmpdir }}/globalTypes.d.lua" --defs=testez.d.lua --ignore=**/_Index/** {{ plugin_source }}
