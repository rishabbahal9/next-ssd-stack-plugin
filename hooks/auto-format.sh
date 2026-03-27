#!/usr/bin/env bash
# auto-format.sh
# PostToolUse hook (matcher: Write|Edit)
# Runs prettier on .ts, .tsx, and .css files after writes

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only format .ts, .tsx, .css files
EXT="${FILE_PATH##*.}"
case "$EXT" in
  ts|tsx|css)
    bunx prettier --write "$FILE_PATH" 2>/dev/null
    ;;
esac

exit 0
