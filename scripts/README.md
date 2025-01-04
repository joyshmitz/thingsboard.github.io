# ThingsBoard Documentation Scripts

This directory contains utility scripts for managing ThingsBoard documentation.

## Migration Script

### migrate-to-learning.sh

Script for migrating and synchronizing learning materials between the main ThingsBoard documentation and the learning repository.

#### Purpose and Background

This script was created to solve several specific challenges in the ThingsBoard documentation workflow:

1. **Separation of Concerns**
   - Separates learning materials from the main documentation
   - Enables independent development of educational content
   - Allows for different release cycles for docs and learning materials

2. **Content Organization**
   - Maintains a clean structure for learning materials
   - Prevents mixing of different types of documentation
   - Makes it easier to manage and update educational content

3. **Development Workflow**
   - Supports parallel work on documentation and learning materials
   - Enables easy synchronization between repositories
   - Preserves the history of changes through backups

4. **Quality Assurance**
   - Ensures consistent file structure
   - Maintains correct internal links
   - Prevents accidental file overwrites

The script is particularly useful when:
- Reorganizing existing learning materials
- Adding new educational content
- Maintaining consistency between repositories
- Preparing content for different platforms or formats

#### Features

- Creates backups before any modifications
- Verifies and creates necessary directory structure
- Synchronizes new files without overwriting existing ones
- Updates markdown file links to match the new structure
- Provides colored logging output

#### Prerequisites

- Unix-like environment (Linux or macOS)
- `rsync` installed
- Proper file permissions

#### Usage

```bash
./migrate-to-learning.sh
```

#### Directory Structure

The script expects the following directory structure:

```
thingsboard.github.io/
├── docs/
│   └── learning/          # Source learning materials
├── images/
│   └── learning/          # Source images
├── learning-thingsboard/  # Target learning repository
│   ├── lessons/
│   ├── docs/
│   ├── assets/
│   └── scripts/
└── scripts/
    └── migrate-to-learning.sh
```

#### Backup

Before any modifications, the script creates a backup in:
```
thingsboard.github.io/backups/YYYYMMDD_HHMMSS/
```

#### Configuration

Main configuration variables in the script:

```bash
SOURCE_DIR="/Users/sd/GitHub/tb/thingsboard.github.io"
LEARNING_DIR="$SOURCE_DIR/learning-thingsboard"
BACKUP_DIR="$SOURCE_DIR/backups/$(date +%Y%m%d_%H%M%S)"
```

#### Error Handling

- Script uses `set -e` to stop on any error
- Provides colored output for different message types:
  - INFO: Regular progress messages
  - WARNING: Non-critical issues
  - ERROR: Critical issues that stop execution

#### Contributing

When modifying the script:
1. Test changes in a safe environment first
2. Maintain the backup functionality
3. Keep the logging consistent
4. Update this README if adding new features
