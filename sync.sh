#!/bin/bash
set -e

# C# Coding Guides Sync Script (Linux/Mac)
# Syncs agents and skills to Claude Code global directories

# Parse arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Usage: $0 [--dry-run|-n]"
            exit 1
            ;;
    esac
done

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.csharp-guides-backup/$(date +%Y%m%d-%H%M%S)"

if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 C# Coding Guides Sync - DRY RUN MODE"
    echo "Repository: $REPO_DIR"
    echo "⚠️  No changes will be made - showing what would happen"
else
    echo "🔄 C# Coding Guides Sync"
    echo "Repository: $REPO_DIR"
fi

# Create backup directory
if [[ "$DRY_RUN" == "true" ]]; then
    echo "📦 Would create backup directory: $BACKUP_DIR"
else
    mkdir -p "$BACKUP_DIR"
fi

# Detect OS for path differences
if [[ "$OSTYPE" == "darwin"* ]]; then
    CLAUDE_DIR="$HOME/.claude"
else
    CLAUDE_DIR="$HOME/.claude"
fi

echo "📁 Target directory: $CLAUDE_DIR"

# Backup existing configs
backup_if_exists() {
    local source="$1"
    local name="$2"
    if [[ -e "$source" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "💾 Would backup existing $name from $source"
        else
            echo "💾 Backing up existing $name"
            cp -r "$source" "$BACKUP_DIR/$name"
        fi
    fi
}

# Sync Agents
if [[ -d "$REPO_DIR/agents" ]]; then
    echo "🤖 Syncing agents..."

    backup_if_exists "$CLAUDE_DIR/agents" "agents"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo "  📁 Would create directory: $CLAUDE_DIR/agents"
    else
        mkdir -p "$CLAUDE_DIR/agents"
    fi

    for agent_file in "$REPO_DIR/agents/"*.md; do
        if [[ -f "$agent_file" ]]; then
            agent_name=$(basename "$agent_file")

            if [[ "$DRY_RUN" == "true" ]]; then
                echo "  📄 Would copy: $agent_name"
            else
                cp "$agent_file" "$CLAUDE_DIR/agents/$agent_name"
            fi
        fi
    done

    if [[ "$DRY_RUN" == "false" ]]; then
        agent_count=$(ls -1 "$REPO_DIR/agents/"*.md 2>/dev/null | wc -l)
        echo "  ✅ Synced $agent_count agents"
    fi
fi

# Sync Skills
if [[ -d "$REPO_DIR/skills" ]]; then
    echo "🎯 Syncing skills..."

    backup_if_exists "$CLAUDE_DIR/skills" "skills"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo "  📁 Would create directory: $CLAUDE_DIR/skills"
    else
        mkdir -p "$CLAUDE_DIR/skills"
    fi

    for skill_file in "$REPO_DIR/skills/"*.md; do
        if [[ -f "$skill_file" ]]; then
            skill_name=$(basename "$skill_file")

            if [[ "$DRY_RUN" == "true" ]]; then
                echo "  📄 Would copy: $skill_name"
            else
                cp "$skill_file" "$CLAUDE_DIR/skills/$skill_name"
            fi
        fi
    done

    if [[ "$DRY_RUN" == "false" ]]; then
        skill_count=$(ls -1 "$REPO_DIR/skills/"*.md 2>/dev/null | wc -l)
        echo "  ✅ Synced $skill_count skills"
    fi
fi

echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 Dry run complete - no changes made!"
    echo "📦 Would have created backup at: $BACKUP_DIR"
    echo ""
    echo "💡 Run without --dry-run to actually sync"
else
    echo "✨ Sync complete!"
    echo "📦 Backup created at: $BACKUP_DIR"
    echo ""
    echo "⚠️  Remember:"
    echo "  - Restart Claude Code to load new agents and skills"
    echo "  - These are global settings - available in all projects"
fi
