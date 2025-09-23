# Unfreeze job which have tags like `t`.
export def fgr [ t: string ]: nothing -> nothing {
    let jobs = job list | where tag like $t
    if ($jobs | is-empty) {
        error make {msg: $"can't find a job with given tag `($t)`"}
    } else if ($jobs | length) == 1 {
        job unfreeze ($jobs | get id.0)
    } else {
        print -e "Have selected more than 1 jobs"
        # don't print job id to make it less confusing.
        print -e ($jobs | reject id pids)
        let index = (input "select the index: ") | into int
        job unfreeze ($jobs | get $index | get id)
    }
}

# Tag a command with latest id
#
# It's useful when you want to tag a job which has just been frozen.
export def tgl [ t: string ]: nothing -> nothing {
    let latest_job_id = job list | sort-by id --reverse | get id.0
    job tag $latest_job_id $t
}