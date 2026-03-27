#!/usr/bin/env bash
# protect-generated.sh
# PreToolUse hook (matcher: Write|Edit)
# Blocks writes to generated/build artifact directories

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Block writes to generated directories
if echo "$FILE_PATH" | grep -qE '(drizzle/meta/|node_modules/|\.next/)'; then
  echo "Blocked: cannot write to generated/build artifacts. Path: $FILE_PATH" >&2
  exit 2
fi

exit 0
