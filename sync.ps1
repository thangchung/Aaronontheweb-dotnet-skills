# C# Coding Guides Sync Script (Windows PowerShell)
# Syncs agents and skills to Claude Code global directories

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BackupDir = Join-Path $env:USERPROFILE ".csharp-guides-backup\$(Get-Date -Format 'yyyyMMdd-HHmmss')"

if ($DryRun) {
    Write-Host "[DRY RUN] C# Coding Guides Sync - DRY RUN MODE" -ForegroundColor Yellow
    Write-Host "Repository: $RepoDir"
    Write-Host "[WARNING] No changes will be made - showing what would happen" -ForegroundColor Yellow
} else {
    Write-Host "[SYNC] C# Coding Guides Sync" -ForegroundColor Cyan
    Write-Host "Repository: $RepoDir"
}

# Create backup directory
if ($DryRun) {
    Write-Host "[BACKUP] Would create backup directory: $BackupDir" -ForegroundColor Yellow
} else {
    New-Item -Path $BackupDir -ItemType Directory -Force | Out-Null
}

# Target directory
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "[DIR] Target directory: $ClaudeDir" -ForegroundColor Yellow

function Backup-IfExists {
    param($Source, $Name)
    if (Test-Path $Source) {
        if ($DryRun) {
            Write-Host "[BACKUP] Would backup existing $Name from $Source" -ForegroundColor Yellow
        } else {
            Write-Host "[BACKUP] Backing up existing $Name" -ForegroundColor Green
            Copy-Item -Path $Source -Destination (Join-Path $BackupDir $Name) -Recurse -Force
        }
    }
}

# Sync Agents
$AgentsSource = Join-Path $RepoDir "agents"
if (Test-Path $AgentsSource) {
    Write-Host "[AGENTS] Syncing agents..." -ForegroundColor Cyan

    $AgentsTarget = Join-Path $ClaudeDir "agents"
    Backup-IfExists $AgentsTarget "agents"

    if ($DryRun) {
        Write-Host "  [DIR] Would create directory: $AgentsTarget" -ForegroundColor Yellow
    } else {
        New-Item -Path $AgentsTarget -ItemType Directory -Force | Out-Null
    }

    $AgentFiles = Get-ChildItem -Path $AgentsSource -Filter "*.md"
    foreach ($AgentFile in $AgentFiles) {
        $AgentName = $AgentFile.Name

        if ($DryRun) {
            Write-Host "  [COPY] Would copy: $AgentName" -ForegroundColor Yellow
        } else {
            Copy-Item -Path $AgentFile.FullName -Destination (Join-Path $AgentsTarget $AgentName) -Force
        }
    }

    if (-not $DryRun) {
        $AgentCount = $AgentFiles.Count
        Write-Host "  [OK] Synced $AgentCount agents" -ForegroundColor Green
    }
}

# Sync Skills
$SkillsSource = Join-Path $RepoDir "skills"
if (Test-Path $SkillsSource) {
    Write-Host "[SKILLS] Syncing skills..." -ForegroundColor Cyan

    $SkillsTarget = Join-Path $ClaudeDir "skills"
    Backup-IfExists $SkillsTarget "skills"

    if ($DryRun) {
        Write-Host "  [DIR] Would create directory: $SkillsTarget" -ForegroundColor Yellow
    } else {
        New-Item -Path $SkillsTarget -ItemType Directory -Force | Out-Null
    }

    $SkillFiles = Get-ChildItem -Path $SkillsSource -Filter "*.md"
    foreach ($SkillFile in $SkillFiles) {
        $SkillName = $SkillFile.Name

        if ($DryRun) {
            Write-Host "  [COPY] Would copy: $SkillName" -ForegroundColor Yellow
        } else {
            Copy-Item -Path $SkillFile.FullName -Destination (Join-Path $SkillsTarget $SkillName) -Force
        }
    }

    if (-not $DryRun) {
        $SkillCount = $SkillFiles.Count
        Write-Host "  [OK] Synced $SkillCount skills" -ForegroundColor Green
    }
}

Write-Host ""
if ($DryRun) {
    Write-Host "[DRY RUN] Dry run complete - no changes made!" -ForegroundColor Yellow
    Write-Host "[BACKUP] Would have created backup at: $BackupDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[TIP] Run without -DryRun to actually sync" -ForegroundColor Cyan
} else {
    Write-Host "[SUCCESS] Sync complete!" -ForegroundColor Green
    Write-Host "[BACKUP] Backup created at: $BackupDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[REMEMBER]:" -ForegroundColor Yellow
    Write-Host "  - Restart Claude Code to load new agents and skills"
    Write-Host "  - These are global settings - available in all projects"
}
