# Query for the meaning of `word`.  And save the meaning locally to `dict_file_name`
#
# Note that `dict_file_name` should be a json file
export def main [word: string, dict_file_name: path] {
    if not ($dict_file_name | path exists) {
        "{}" o> $dict_file_name
    }
    if not ($dict_file_name | str ends-with ".json") {
        error make {msg: "dict_file_name should be a json file, which is end with .json"}
    }
    let dict_data = open $dict_file_name
    if $word in $dict_data {
        return ($dict_data | get $word)
    } else {
        # query from web
        let body = http get $"https://www.oxfordlearnersdictionaries.com/search/english/?q=($word)" -m 4sec
        let result = $body | query web --query  'span[class="def"]' | each {|it| $it | str join ''} | flatten
        if (not ($result | is-empty)) {
            let dict_data = $dict_data | upsert $word $result
            $dict_data | to json -r | save -rf $dict_file_name
            $result
        } else {
            let spell_check = $body | query web --query 'div[id="results-container-all"]' |
                flatten |
                str trim |
                take until {|x| $x | str starts-with "Nearest results from our other dictionaries and grammar usage guide" } |
                filter {|x| ($x | str length) != 0} |
                str join "\n\n"
            $spell_check
        }
    }
}
