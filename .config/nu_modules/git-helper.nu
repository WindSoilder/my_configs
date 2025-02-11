# delete branches except given `excepts` list
export def del-branches [
    excepts:list   # don't delete branch in the list
    --remote       # remove remote branch too?
 ] {
    let branches = (git branch | lines | str trim)
    $branches | each {|it|
        if ($it not-in $excepts) and (not ($it | str starts-with "*")) {
            git branch -D $it
            if $remote {
                do -i { git push -u origin $":($it)" }
            }
        }
    }
}

export def del-remote-branches [
    excepts: list   # don't delete branch in the list
] {
    let excepts = $excepts | append ['master', 'main', 'develop']
    let branch = git branch -r | lines | str trim
    let branch = $branch | filter {|r| ($r | str starts-with "origin/") and ($r | str starts-with "origin/HEAD" | not $in)}
    let branch_names = $branch | each {|r| parse "origin/{name}" | get name } | flatten
    for name in $branch_names {
        if ($name not-in $excepts) {
            do -i { git push -u origin $":($name)" }
        }
    }
}

# wrapper for git push and copy pull request link
export def push-show-pr [copy_to_board: bool = true]: nothing -> string {
    let current_branch = (git branch --show-current)
    let push_output = (do { git push -u origin $current_branch } | complete | get stderr | lines)
    mut pr_prompt_index = -1
    for l in ($push_output | enumerate) {
        if (($l.item | str contains "Create pull request") or ($l.item | str contains "View pull request")) {
            $pr_prompt_index = $l.index
            break
        }
    }
    if $pr_prompt_index != -1 {
        let target_line = ($push_output | get ($pr_prompt_index + 1))
        let pr_link = ($target_line | parse '{link}: {url}' | get url.0 | str trim)
        if $copy_to_board {
            $pr_link | pbcopy
        }
        $pr_link
    } else {
        error make -u {msg: $"can't find pr link, full push message\n: ($push_output)"}
    }
}

# push current branch to remote.
export def push-head [] {
    git push -u origin HEAD
}

def check_duplicate_input [] {
    let commands_info = (help commands | select name input_output)
    mut invalid_cmds = []
    for c in $commands_info {
        mut input_types = []
        mut duplicate_input_types = []
        for one_input_output in $c.input_output {
            let input = $one_input_output | get input
            if $input in $input_types {
                $duplicate_input_types = ($duplicate_input_types | append $input)
            } else {
                $input_types = ($input_types | append $input)
            }
        }

        if not ($duplicate_input_types | is-empty) {
            $invalid_cmds = ($invalid_cmds | append {"name": ($c | get name), "input_type": $duplicate_input_types})
        }
    }
    $invalid_cmds
}

# a wrapper for `gh pr diff <pr_num>`, but using a difftool.
#
# Required: 
# 1. [gh-difftool](https://github.com/speedyleion/gh-difftool)
# 2. [difftastic](https://github.com/Wilfred/difftastic)
# 3. [gh cli](https://cli.github.com/)
export def ghdiff [pr_num: int] {
    gh difftool $pr_num | less -R
}
