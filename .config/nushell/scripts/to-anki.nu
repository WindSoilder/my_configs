export def main [dict_file: path] {
    let file_name = $dict_file | split row "." | get 0
    let dict_data = open $dict_file
    # the first line is a flag
    let anki_data_list = ["a;b"]
    let anki_lines = $dict_data | items {|key, value| 
        let value = $value | str replace '"' '""' | str join "\n"
        # wrap the value with a quote.
        let value = $"\"($value)\""
        $"($key);($value)"
    }
    let final_data = $anki_data_list| append $anki_lines | str join "\n"
    $final_data o> $"($file_name).txt"
}

def anki-to-json [anki_path: path] {
    let anki_data = open $anki_path | lines
    # the first line is a flag, just skip it.
    let anki_data = $anki_data | skip 1
    let json_data = $anki_data 2
}

export def update-anki [dict_file: path, orig_anki: path] {
    

}
