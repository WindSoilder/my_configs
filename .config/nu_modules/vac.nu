export def main [word: string] {
    let dict_data = open "baldur-gate-3.json"
    if $word in $dict_data {
        return ($dict_data | get $word)
    } else {
        # query from web
        try {
            let result = http get $"https://www.oxfordlearnersdictionaries.com/definition/english/($word)?q=($word)" -m 4 |
                query web --query 'span[class="def"]' | each {|it| $it | str join ''} | flatten
            let dict_data = $dict_data | upsert $word $result
            $dict_data | to json -r | save -rf "baldur-gate-3.json"
            $result
        } catch {|e| 
                if (($e | get msg) == "Network failure") and ("404" in ($e | get debug)) {
                    let spell_check = http get $"https://www.oxfordlearnersdictionaries.com/spellcheck/english/?q=($word)" -m 4 |
                        query web --query 'div[id="results-container-all"]' | flatten |
                        str trim | filter {|x| ($x | str length) != 0} | str join "\n\n"
                    $spell_check
            } else {
                error make ($e | get raw)
            }
        }
    }
}
