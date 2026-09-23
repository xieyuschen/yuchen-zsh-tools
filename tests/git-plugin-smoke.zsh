#!/usr/bin/env zsh
set -eu

repo_root="${0:A:h:h}"
plugin="$repo_root/yuchen-zsh-tools.plugin.zsh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/repo"

source "$plugin"

cd "$tmpdir/repo"
git init -q

gitmine
if [ "$(git config --local --get user.email)" != "xieyuschen@gmail.com" ]; then
	echo "gitmine did not configure user.email" >&2
	exit 1
fi
if [ "$(git config --local --get user.name)" != "xieyuschen" ]; then
	echo "gitmine did not configure user.name" >&2
	exit 1
fi

gitbot
if [ "$(git config --local --get user.email)" != "auswater@dangui.org" ]; then
	echo "gitbot did not configure user.email" >&2
	exit 1
fi
if [ "$(git config --local --get user.name)" != "auswater" ]; then
	echo "gitbot did not configure user.name" >&2
	exit 1
fi

echo "ok"
