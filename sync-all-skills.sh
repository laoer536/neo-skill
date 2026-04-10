#!/bin/bash

# Sync all skills from repo to ~/.qoder/skills/
# Usage: ./sync-all-skills.sh

# ============================================
# Configuration - Modify these paths as needed
# ============================================

# Source: Path to your skills directory in the repository
SKILLS_SOURCE="/Users/neo/Desktop/neo/github/neo-skill/skills"

# Target: Path to your AI platform's skills directory
# Different AI platforms use different paths:
#   - Qoder:        ~/.qoder/skills
#   - Cursor:       ~/.cursor/skills
#   - GitHub Copilot: ~/.github/skills (if supported)
#   - Custom:       /your/custom/path/skills
SKILLS_TARGET="$HOME/.qoder/skills"

echo "🚀 Syncing all skills from repository..."
echo ""

# Check if source directory exists
if [ ! -d "$SKILLS_SOURCE" ]; then
  echo "❌ Error: Skills source directory not found at $SKILLS_SOURCE"
  exit 1
fi

# Counter for synced skills
SYNCED=0
SKIPPED=0
ERRORS=0

# Iterate through all skill directories
for skill_dir in "$SKILLS_SOURCE"/*/; do
  # Skip if not a directory
  [ -d "$skill_dir" ] || continue
  
  # Get skill name
  skill_name=$(basename "$skill_dir")
  
  # Check if SKILL.md exists
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "⚠️  Skipping '$skill_name' (no SKILL.md found)"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  
  echo "📦 Syncing: $skill_name"
  
  # Create target directory
  target_dir="$SKILLS_TARGET/$skill_name"
  mkdir -p "$target_dir"
  
  # Copy SKILL.md
  cp "$skill_dir/SKILL.md" "$target_dir/SKILL.md"
  
  # Copy references directory if it exists
  if [ -d "$skill_dir/references" ]; then
    mkdir -p "$target_dir/references"
    cp "$skill_dir/references/"*.md "$target_dir/references/" 2>/dev/null
  fi
  
  # Copy other files (LICENSE.md, GENERATION.md, SYNC.md, etc.)
  for file in "$skill_dir"/*.md; do
    [ -f "$file" ] || continue
    filename=$(basename "$file")
    if [ "$filename" != "SKILL.md" ]; then
      cp "$file" "$target_dir/$filename"
    fi
  done
  
  # Copy command directory if it exists
  if [ -d "$skill_dir/command" ]; then
    mkdir -p "$target_dir/command"
    cp -r "$skill_dir/command/"* "$target_dir/command/" 2>/dev/null
  fi
  
  echo "   ✅ Synced to $target_dir"
  SYNCED=$((SYNCED + 1))
  echo ""
done

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Sync completed!"
echo ""
echo "📊 Statistics:"
echo "   ✅ Synced:  $SYNCED skills"
[ $SKIPPED -gt 0 ] && echo "   ⚠️  Skipped: $SKIPPED skills (no SKILL.md)"
[ $ERRORS -gt 0 ] && echo "   ❌ Errors:  $ERRORS skills"
echo ""
echo "📍 Target: $SKILLS_TARGET"
echo ""
echo "📋 Installed skills:"
ls -1 "$SKILLS_TARGET" | sed 's/^/   • /'
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
