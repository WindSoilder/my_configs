# delete branches except given `excepts` list
export def del-branches (
    excepts:list   # don't delete branch in the list
) {
    let branches = (git branch | lines | str trim)
    $branches | each {|it|
        if ($it not-in $excepts) and (not ($it | str starts-with "*")) {
            git branch -D $it
        }
    }
}

