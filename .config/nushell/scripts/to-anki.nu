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

