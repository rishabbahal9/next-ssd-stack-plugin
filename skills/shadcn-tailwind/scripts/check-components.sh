#!/usr/bin/env bash
# Lists installed Shadcn UI components in components/ui/

UI_DIR="${1:-components/ui}"

if [ ! -d "$UI_DIR" ]; then
  echo "No Shadcn UI components found at $UI_DIR"
  exit 0
fi

echo "Installed Shadcn components in $UI_DIR:"
for file in "$UI_DIR"/*.tsx; do
  [ -f "$file" ] && echo "  - $(basename "$file" .tsx)"
done
