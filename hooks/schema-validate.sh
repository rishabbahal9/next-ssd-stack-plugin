#!/usr/bin/env bash
# schema-validate.sh
# PostToolUse hook (matcher: Write|Edit)
# Runs drizzle-kit check when files in db/schema/ are modified

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')

# Only trigger for db/schema/ files
if ! echo "$FILE_PATH" | grep -q "db/schema/"; then
  exit 0
fi

OUTPUT=$(bunx drizzle-kit check 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "Schema validation failed after editing $FILE_PATH:" >&2
  echo "$OUTPUT" >&2
  exit $EXIT_CODE
fi

exit 0
