#!/bin/bash

filter_bash_history() {
  file="${1:-$HISTFILE}"
  backup="$file.before-filtering.bak"
  \mv "$file" "$backup"

  # trim leading and trailing whitespace
  cat "$backup" | sed -r 's/^\s+//; s/\s+$//' |

  # put timestamp and command in one line
  sed -n '/^#[0-9]*$/!{s/^/#0000000000 /; p}' |

  # deduplicate, keeping last occurrence (https://stackoverflow.com/a/39076527)
  tac | awk '!uniq[substr($0, 12)]++' | tac |

  # split entries in two lines again
  sed -r 's/^(#[0-9]*) /\1\n/' > "$file"

  echo Done. Original history saved to \"$backup\".
}
