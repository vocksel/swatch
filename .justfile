#!/usr/bin/env just --justfile

set dotenv-load

project_name := "rbxtheme"
plugins_dir := if os_family() == "unix" {
	"$HOME/Documents/Roblox/Plugins"
} else {
	"$LOCALAPPDATA/Roblox/Plugins"
}

plugin_root := absolute_path("plugin")
plugin_source := plugin_root / "src"
plugin_project := plugin_root / "tests.project.json"
plugin_filename := project_name + ".rbxm"
plugin_output := plugins_dir / plugin_filename

server_root := absolute_path("server")
server_source := server_root / "src"
server_project := server_root / "default.project.json"

testez_defs_path := absolute_path("testez.d.lua")
global_defs_path := tmpdir / "globalTypes.d.lua"
sourcemap_path := tmpdir / "sourcemap.json"

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

_get-plugin-name:
	jq -r .name {{ plugin_root / "default.project.json" }}

_build target output watch:
	-mkdir -p {{ parent_directory(output) }}
	./bin/build.py --target {{ target }} --project-path {{ plugin_root }} --output {{ output }} \
		{{ if watch == "true"  { "--watch" } else { "" } }}

init:
	foreman install
	lune --setup
	just wally-install

wally-install:
	wally install --project-path {{ plugin_root }}
	rojo sourcemap {{ plugin_project }} -o {{ sourcemap_path }}
	cd plugin && wally-package-types --sourcemap {{ sourcemap_path }} Packages/

build target="prod":
	just _build {{ target }} {{ plugin_output }} false

build-watch target="prod":
	just _build {{ target }} {{ plugin_output }} true

build-here target="prod" filename=plugin_filename:
	just _build {{ target }} {{ filename }} false

test: clean
    rojo build {{ plugin_project }} -o {{ tmpdir / "tests.rbxl" }}
    run-in-roblox --place {{ tmpdir / "tests.rbxl" }} --script tests/init.server.lua

serve:
	docker compose up

plugin-analyze:
	curl -s -o {{ global_defs_path }} \
		-O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/master/scripts/globalTypes.d.lua

	rojo sourcemap {{ plugin_project }} -o {{ sourcemap_path }}

	luau-lsp analyze --sourcemap={{ sourcemap_path }} \
		--defs={{ global_defs_path }} \
		--defs={{ testez_defs_path }} \
		--ignore=**/_Index/** \
		{{ plugin_source }}

server-analyze:
	rojo sourcemap {{ server_project }} -o {{ sourcemap_path }}
	luau-lsp analyze --sourcemap={{ sourcemap_path }} server/src/

analyze:
	just plugin-analyze
	just server-analyze
