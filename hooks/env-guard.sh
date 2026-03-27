#!/usr/bin/env bash
# env-guard.sh
# PreToolUse hook (matcher: Bash)
# Blocks bash commands that may expose environment variables

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block: cat .env or cat .env.*
if echo "$COMMAND" | grep -qE 'cat\s+\.env(\.\S*)?(\s|$)'; then
  echo "Blocked: command may expose environment variables." >&2
  exit 2
fi

# Block: echo $SENSITIVE_VAR or printenv/env dumps
if echo "$COMMAND" | grep -qE '(echo\s+\$[A-Z_]*(KEY|SECRET|TOKEN|PASSWORD|SERVICE_ROLE)[A-Z_]*|^\s*printenv\s*$|^\s*env\s*$)'; then
  echo "Blocked: command may expose environment variables." >&2
  exit 2
fi

# Block: env | grep, printenv with sensitive var names
if echo "$COMMAND" | grep -qE '(printenv|env)\s+(SUPABASE|DATABASE|SECRET|API_KEY|SERVICE_ROLE)'; then
  echo "Blocked: command may expose environment variables." >&2
  exit 2
fi

exit 0
