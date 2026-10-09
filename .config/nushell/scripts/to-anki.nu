export def main [dict_file: path] {
    let file_name = $dict_file | split row "." | get 0
    let dict_data = open $dict_file
    # the first line is a flag
    let anki_data_list = ["a;b"]
    let anki_lines = $dict_data | items {|key, value| 
        let value = $value | str replace '"' '""' | str join "\n"
        # wrap the value with a quote.
        let value = $"\"($value)\""
        # a key may contains example.  If so, we need to do the same job like value.
        let key = $key | str replace '"' '""' | str join "\n"
        # wrap the key with a quote.
        let key = $"\"($key)\""
        $"($key);($value)"
    }
    let final_data = $anki_data_list| append $anki_lines | str join "\n"
    $final_data o> $"($file_name).txt"
}

export def to-json [anki_file: path] {
    let rows = open $anki_file | lines | skip 2
    let json_file = $anki_file | split row "." | get 0
    let json_file = $"($json_file).json"
    $rows | each {|one_row|
        let info = $one_row | split row "\t"
        let name_and_examples = $info | get 0 | str replace "<br>" "\n" -a
        let definitions = $info | get 1 | split row "<br>"
        {$name_and_examples: $definitions}
    } | to json -r | save -f $json_file
}
