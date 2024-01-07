#!/usr/bin/env just --justfile

project_name := "rbxtheme"
plugins_dir := if os_family() == "unix" {
	"$HOME/Documents/Roblox/Plugins"
} else {
	"$LOCALAPPDATA/Roblox/Plugins"
}
plugin_filename := project_name + ".rbxm"
plugin_path := plugins_dir / plugin_filename
tmpdir := `mktemp -d`

default:
  @just --list

clean:
	rm -rf {{plugin_path}}

lint:
	selene src/
	stylua --check src/

_build target watch:
	./bin/build.py --target {{target}} --output {{ plugin_path }} {{ if watch == "true"  { "--watch" } else { "" } }}

wally-install:
	wally install
	rojo sourcemap tests.project.json -o "{{tmpdir}}/sourcemap.json"
	wally-package-types --sourcemap "{{tmpdir}}/sourcemap.json" Packages/

build target="prod":
	just _build {{target}} false

build-watch target="prod":
	just _build {{target}} true

build-here target="prod" filename=plugin_filename:
	./bin/build.py --target {{target}} --output {{ filename }}

test: clean
    rojo build tests.project.json -o {{tmpdir / "tests.rbxl"}}
    run-in-roblox --place {{tmpdir / "tests.rbxl"}} --script tests/init.server.lua

analyze:
  curl -s -o "{{tmpdir}}/globalTypes.d.lua" -O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/master/scripts/globalTypes.d.lua

  rojo sourcemap tests.project.json -o "{{tmpdir}}/sourcemap.json"

  luau-lsp analyze --sourcemap="{{tmpdir}}/sourcemap.json" --defs="{{tmpdir}}/globalTypes.d.lua" --defs=testez.d.lua --ignore=**/_Index/** src/
