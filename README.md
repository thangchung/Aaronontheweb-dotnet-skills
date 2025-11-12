# C# Coding Guides

A collection of comprehensive C# coding standards, best practices, and specialized knowledge for modern .NET development.

## Structure

### Skills (`/skills`)

Detailed guides and patterns for specific C# and .NET technologies:

- **modern-csharp-coding-standards.md** - Comprehensive modern C# best practices including records, pattern matching, value objects, async/await, Span<T>/Memory<T>, and API design
- **akka-net-testing-patterns.md** - Complete guide to testing Akka.NET actors using Akka.Hosting.TestKit
- **akka-net-aspire-configuration.md** - Patterns for configuring Akka.NET with .NET Aspire
- **aspire-integration-testing.md** - Testing strategies for .NET Aspire applications
- **testcontainers-integration-tests.md** - Using Testcontainers for integration testing in .NET
- **playwright-blazor-testing.md** - End-to-end testing for Blazor applications with Playwright

### Agents (`/agents`)

Specialized agent configurations for domain-specific expertise:

- **akka-net-specialist.md** - Expert in Akka.NET architecture, actor systems, and distributed computing
- **dotnet-concurrency-specialist.md** - Expert in .NET concurrency, threading, and race condition analysis
- **dotnet-benchmark-designer.md** - Expert in designing effective .NET performance benchmarks
- **dotnet-performance-analyst.md** - Expert in analyzing .NET application performance data
- **docfx-specialist.md** - Expert in DocFX documentation system and markdown formatting

## Key Principles

These guides emphasize:

- **Immutability by default** - Records and value objects
- **Type safety** - Nullable reference types and strong typing
- **Modern patterns** - Pattern matching, async/await everywhere
- **Performance** - Zero-allocation patterns with Span<T>/Memory<T>
- **Composition over inheritance** - Avoid abstract base classes
- **Best-practice API design** - Accept abstractions, return appropriately specific types

## Usage

These guides are designed to be used with AI-assisted development tools as knowledge bases for maintaining consistent coding standards across projects.

### Syncing to Claude Code

Use the provided sync scripts to copy agents and skills to your Claude Code global configuration directory (`~/.claude`):

#### Linux/Mac
```bash
# Full sync
./sync.sh

# Dry run (see what would happen without making changes)
./sync.sh --dry-run
# or
./sync.sh -n
```

#### Windows
```powershell
# Full sync
.\sync.ps1

# Dry run (see what would happen without making changes)
.\sync.ps1 -DryRun
```

**Important Notes:**
- Sync scripts create timestamped backups before making changes
- Restart Claude Code after syncing to load new configurations
- These are **global settings** - agents and skills will be available in all projects
- Changes should be made in this repository, not in local `~/.claude` directories

## License

Private collection - not for distribution.
