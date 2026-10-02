# Query for the meaning of `word`.  And save the meaning locally to `dict_file_name`
#
# Note that `dict_file_name` should be a json file
#
# data format (v1):
# {"word": [def1, def2, def3]}
# data format (v2):
# {"word\n- example1\n- example2": [def1, def2, def3]}
# the key or v2 looks ugly, but the dict itself is compatible with v1.
export def main [word: string, dict_file_name: path] {
    if not ($dict_file_name | path exists) {
        "{}" o> $dict_file_name
    }
    if not ($dict_file_name | str ends-with ".json") {
        error make {msg: "dict_file_name should be a json file, which is end with .json"}
    }
    let dict_data = open $dict_file_name

    # some keys may contain examples, some keys doesn't
    # so to search if word in $dict_data, we need to search word without example
    let query_dict = $dict_data |
        items {|key, val|
          let key_and_examples = $key | split row "\n"
          [
              ($key_and_examples | first),
              {"d": $val, "e": ($key_and_examples | skip 1)}
          ]}
        | into record
    if $word in $query_dict {
        let val = $query_dict | get $word
        if ($val | get "e" | is-not-empty) {
            return $val
        } else {
            return ($val | get "d")
        }
    } else {
        # query from web
        let body = http get $"https://www.oxfordlearnersdictionaries.com/search/english/?q=($word)" -m 7sec
        let definitions = $body | query web --query  'span[class="def"]' | each {|it| $it | str join ''} | flatten
        let examples = $body | query web --query 'ul.examples:not(div.collapse *) > li:first-child' |
            each {|it|
                $it | where ($it | str trim) != "" | str join ' '
            } |
            first 2 |
            each {|it| "- " + $it}
        let word_with_examples = if ($examples | is-empty) {
            $word
        } else {
            $word + "\n" + ($examples | str join "\n")
        };
        if (not ($definitions | is-empty)) {
            let dict_data = $dict_data | upsert $word_with_examples $definitions
            $dict_data | to json -r | save -rf $dict_file_name
            # just using a simple character `d` and `e`
            if ($examples | is-not-empty) {
               {"d": $definitions, "e": $examples}
            } else {
                $definitions
            }
        } else {
            let spell_check = $body | query web --query 'div[id="results-container-all"]' |
                flatten |
                str trim |
                take until {|x| $x | str starts-with "Nearest results from our other dictionaries and grammar usage guide" } |
                where {|x| ($x | str length) != 0} |
                str join "\n\n"
            $spell_check
        }
    }
}

export def vl [word: string] {
    main $word ~/dicts/life.json
}

export def va [word: string] {
    main $word ~/dicts/age_of_empire.json
}

export def vp [word: string] {
    main $word ~/dicts/pg_books.json
}

export def vb [word: string] {
    main $word ~/dicts/baldur-gate.json
}

export def vs [word: string] {
    main $word ~/dicts/skyrim.json
}
