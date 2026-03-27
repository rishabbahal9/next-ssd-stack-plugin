#!/usr/bin/env bash
# enforce-drizzle.sh
# PreToolUse hook (matcher: Write|Edit)
# Blocks raw SQL in application code; only allows it in db/migrations/

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // ""')

# Allow raw SQL in migration files
if echo "$FILE_PATH" | grep -q "db/migrations/"; then
  exit 0
fi

# Detect raw SQL patterns: db.execute(sql`...`) or db.execute(`SELECT...)
if echo "$CONTENT" | grep -qE 'db\.execute\s*\(|\.execute\s*\(\s*sql`|\.execute\s*\(\s*`\s*(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER)'; then
  echo "Use Drizzle query builder instead of raw SQL. Raw SQL is only allowed in db/migrations/." >&2
  exit 2
fi

exit 0
