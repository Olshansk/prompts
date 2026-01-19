#!/bin/bash
# Find latest screenshot on Desktop
latest=$(ls -t ~/Desktop/Screenshot*.png 2>/dev/null | head -1)

if [[ -n "$latest" ]]; then
  # Output JSON telling Claude to read the file
  cat <<EOF
{
  "continue": true,
  "systemMessage": "The user referenced @latest_screenshot. Please read and analyze this file: $latest"
}
EOF
else
  cat <<EOF
{
  "continue": true,
  "systemMessage": "No screenshots found on ~/Desktop matching Screenshot*.png"
}
EOF
fi
