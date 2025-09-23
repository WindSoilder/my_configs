#!/usr/bin/env nu
def main [f, s] {
    ~/.cargo/bin/difft --color=always $f $s
}