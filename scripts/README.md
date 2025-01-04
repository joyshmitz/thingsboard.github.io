# ThingsBoard Documentation Scripts

This directory contains utility scripts for managing ThingsBoard documentation.

## Migration Script

### migrate-to-learning.sh

Script for migrating and synchronizing learning materials between the main ThingsBoard documentation and the learning repository.

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
  - 🟢 INFO: Regular progress messages
  - 🟡 WARNING: Non-critical issues
  - 🔴 ERROR: Critical issues that stop execution

#### Contributing

When modifying the script:
1. Test changes in a safe environment first
2. Maintain the backup functionality
3. Keep the logging consistent
4. Update this README if adding new features
