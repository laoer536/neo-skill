#!/bin/bash

# Interactive script to sync selected skills to AI platform
# Usage: ./sync-skill.sh

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

# ============================================
# Functions
# ============================================

# Sync a single skill
sync_skill() {
  local skill_name=$1
  local skill_dir="$SKILLS_SOURCE/$skill_name"
  local target_dir="$SKILLS_TARGET/$skill_name"
  
  # Check if source exists
  if [ ! -d "$skill_dir" ]; then
    echo "❌ Error: Skill '$skill_name' not found in source directory"
    return 1
  fi
  
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "❌ Error: SKILL.md not found for '$skill_name'"
    return 1
  fi
  
  echo ""
  echo "📦 Syncing: $skill_name"
  
  # Create target directory
  mkdir -p "$target_dir"
  
  # Backup existing skill if it exists
  if [ -f "$target_dir/SKILL.md" ]; then
    echo "   ⚠️  Existing skill found, replacing..."
  fi
  
  # Copy SKILL.md
  cp "$skill_dir/SKILL.md" "$target_dir/SKILL.md"
  
  # Copy references directory if it exists
  if [ -d "$skill_dir/references" ]; then
    mkdir -p "$target_dir/references"
    # Remove old references and copy new ones
    rm -rf "$target_dir/references/"*.md 2>/dev/null
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
    rm -rf "$target_dir/command"/* 2>/dev/null
    cp -r "$skill_dir/command/"* "$target_dir/command/" 2>/dev/null
  fi
  
  echo "   ✅ Synced to $target_dir"
  return 0
}

# ============================================
# Main Script
# ============================================

echo "🎯 Interactive Skill Sync"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if source directory exists
if [ ! -d "$SKILLS_SOURCE" ]; then
  echo "❌ Error: Skills source directory not found at $SKILLS_SOURCE"
  exit 1
fi

# Collect all available skills
skills=()
for skill_dir in "$SKILLS_SOURCE"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  
  # Only include skills with SKILL.md
  if [ -f "$skill_dir/SKILL.md" ]; then
    skills+=("$skill_name")
  fi
done

# Check if any skills found
if [ ${#skills[@]} -eq 0 ]; then
  echo "❌ No skills found in $SKILLS_SOURCE"
  exit 1
fi

# Display available skills
echo "📋 Available skills (${#skills[@]} total):"
echo ""

for i in "${!skills[@]}"; do
  num=$((i + 1))
  skill_name="${skills[$i]}"
  
  # Check if already installed
  if [ -f "$SKILLS_TARGET/$skill_name/SKILL.md" ]; then
    echo "  $num) $skill_name ✓ (installed)"
  else
    echo "  $num) $skill_name (new)"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 Input format:"
echo "  - Single: 1"
echo "  - Multiple: 1,3,5"
echo "  - Range: 1-5"
echo "  - Mix: 1,3-5,7"
echo "  - All: all"
echo "  - Quit: q"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Select skill(s) to sync: " selection

# Handle quit
if [ "$selection" = "q" ] || [ "$selection" = "Q" ]; then
  echo "👋 Cancelled"
  exit 0
fi

# Parse selection
selected_skills=()

if [ "$selection" = "all" ] || [ "$selection" = "ALL" ]; then
  selected_skills=("${skills[@]}")
else
  # Split by comma
  IFS=',' read -ra parts <<< "$selection"
  
  for part in "${parts[@]}"; do
    # Trim whitespace
    part=$(echo "$part" | xargs)
    
    # Check if it's a range
    if [[ "$part" == *"-"* ]]; then
      IFS='-' read -ra range <<< "$part"
      start=${range[0]}
      end=${range[1]}
      
      # Validate range
      if ! [[ "$start" =~ ^[0-9]+$ ]] || ! [[ "$end" =~ ^[0-9]+$ ]]; then
        echo "⚠️  Invalid range: $part"
        continue
      fi
      
      for ((i=start; i<=end; i++)); do
        idx=$((i - 1))
        if [ $idx -ge 0 ] && [ $idx -lt ${#skills[@]} ]; then
          selected_skills+=("${skills[$idx]}")
        fi
      done
    else
      # Single number
      if [[ "$part" =~ ^[0-9]+$ ]]; then
        idx=$((part - 1))
        if [ $idx -ge 0 ] && [ $idx -lt ${#skills[@]} ]; then
          selected_skills+=("${skills[$idx]}")
        else
          echo "⚠️  Invalid number: $part"
        fi
      fi
    fi
  done
fi

# Check if any skills selected
if [ ${#selected_skills[@]} -eq 0 ]; then
  echo "❌ No valid skills selected"
  exit 1
fi

# Confirm sync
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Skills to sync (${#selected_skills[@]}):"
for skill in "${selected_skills[@]}"; do
  echo "   • $skill"
done
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Continue? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "👋 Cancelled"
  exit 0
fi

# Sync selected skills
echo ""
echo "🚀 Starting sync..."
echo ""

SYNCED=0
FAILED=0

for skill in "${selected_skills[@]}"; do
  if sync_skill "$skill"; then
    SYNCED=$((SYNCED + 1))
  else
    FAILED=$((FAILED + 1))
  fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Sync completed!"
echo ""
echo "📊 Statistics:"
echo "   ✅ Success: $SYNCED"
[ $FAILED -gt 0 ] && echo "   ❌ Failed:  $FAILED"
echo ""
echo "📍 Target: $SKILLS_TARGET"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
