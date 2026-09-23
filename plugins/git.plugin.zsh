#!/usr/bin/env zsh

checkmaster() {
	branch="$(git rev-parse --abbrev-ref HEAD)"

	if [ "$branch" = "master" ]; then
  		echo "You can't commit directly to master branch"
  		return 1
	fi
}

git_current_branch () {
        local ref
        ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null) 
        local ret=$? 
        if [[ $ret != 0 ]]
        then
                [[ $ret == 128 ]] && return
                ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return
        fi
        echo ${ref#refs/heads/}
}

alias gdf="git diff"
alias cpwd="pwd | clipcopy"
alias ghead="git rev-parse HEAD"
alias gst="git status"
alias glo="git log --oneline --decorate"
alias ci="commit"
alias gam="git add . && git ci --amend --no-edit"
alias gamn="gam --no-verify"
alias gcf="git add . && git commit --fixup "
alias gamend="git ci --amend"
alias gps="checkmaster &&  git push"
alias gpl="git pull"
alias gck="git checkout"
alias gckm="gck master"
alias gre="git restore ."
alias gcl="git clean -fd"
alias gsa="git stash --all"
alias gmt="go mod tidy"
alias gl="git clone"
alias grebase="git rebase -i "
alias gpsupn="gpsup --no-verify"
alias gpsn="checkmaster && git push --no-verify"
alias gpsnf="checkmaster && git push -f --no-verify"
alias opld="open -a goland "
alias rmb="git branch | grep -v "master" | xargs git branch -D"
alias grt="git restore "
alias gcl="git clean -fd"
function gckb {
  if [ -z "$1" ]; then
    echo "Error: Branch name required."
    return 1
  fi
  gck -b "$1"
}

unalias gc 2>/dev/null || true
function gc {
  if [ -z "$1" ]; then
    echo "Error: commit message is required."
    return 1
  fi
  git add . && git ci -m "$1" --no-verify
}

function module {
	remote=$(git remote get-url --push origin | sed 's/^gitlab@//; s/:/\//; s/\.git$//')
	echo "${remote}"
}

function pushtag {
    tag=$(git tag --points-at HEAD | head -n1)
    if [ -n "$tag" ]; then
        echo "git push origin "$tag" --no-verify" | clipcopy
    else
        return 1
    fi
}
function revision {
	tag=$(git tag --points-at HEAD | head -n1)
	if [ -n "$tag" ]; then
		rev="$tag"
	else
		rev=$(git rev-parse HEAD)
	fi
	echo "$rev"
}

unalias gg 2>/dev/null || true
function gg {
	# Try to get the tag pointing to HEAD, otherwise use commit hash
	rev="$(revision)"
	remote=$(module)
	echo "go get ${remote}@${rev}" | clipcopy
}

function project_name {
	remote=$(git remote get-url --push origin | sed 's/^gitlab@//; s/:/\//; s/\.git$//')
	basename=$(basename "$remote")
	echo "$basename"
}

function upstream {
	if [ -z "$1" ]; then
		echo "Error: upstream path required."
		return 1
	fi
	module_name=$(module)
	rev=$(revision)  # Correctly call the revision function

	gg_script="go get ${module_name}@${rev}"

	# 1. Use z to jump, select first, run gg to get script
	path=$(z "$1" -l | head -n1 | awk '{print $2}')
	if [ -z "$path" ]; then
		echo "No matching path found for '$1'"
		return 1
	fi

	cd "$path" || return 1
	if [ -n "$2" ]; then
		branch="$2"
	else
		branch="master"
	fi
	echo "checkout branch: $branch"
	#source ~/.zshenv
	if git show-ref --verify --quiet "refs/heads/$branch"; then
		git checkout "$branch"
	else
		git checkout -b "$branch"
	fi
	branch="upstream/$(basename "$module_name")/${branch}/${rev}"
	git checkout -B "$branch"
	eval "$gg_script" || return 1

	if git diff --quiet && git diff --cached --quiet; then
		echo "No changes to commit."
		return 0
	fi
	git add .
	basename=$(basename "$module_name")
	gc "chore(${basename}): use ${rev}"
}

function git_identity {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "usage: git_identity <email> <name>" >&2
		return 1
	fi

	git config user.email "$1"
	git config user.name "$2"
}

gitmine() {
	git_identity "xieyuschen@gmail.com" "xieyuschen"
}

gitbot(){
	git_identity "auswater@dangui.org" "auswater"
}
