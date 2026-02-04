#!/bin/bash
# ============================================================================
# Cloud Storage Management (rclone & Google Drive)
# ============================================================================

# Configuration
EXCLUDE_FILE="$HOME/rclone-exclude.txt"
GDRIVE_MOUNT_POINT="$HOME/gdrive"
GDRIVE_LOG_FILE="$HOME/gdrive_mount.log"

# ============================================================================
# GOOGLE DRIVE MOUNT/UNMOUNT
# ============================================================================

gdrive() {
    # Create mount point if it doesn't exist
    if [ ! -d "$GDRIVE_MOUNT_POINT" ]; then
        echo "Creating mount point: $GDRIVE_MOUNT_POINT"
        mkdir -p "$GDRIVE_MOUNT_POINT"
    fi

    # Check if already mounted
    if mountpoint -q "$GDRIVE_MOUNT_POINT"; then
        echo "GDrive is already mounted at $GDRIVE_MOUNT_POINT"
        df -h "$GDRIVE_MOUNT_POINT" | tail -1
        return 0
    fi

    echo "Mounting GDrive to $GDRIVE_MOUNT_POINT..."
    
    # Mount with optimized settings
    nohup rclone mount gdrive: "$GDRIVE_MOUNT_POINT" \
        --vfs-cache-mode writes \
        --vfs-cache-max-age 72h \
        --vfs-read-chunk-size 128M \
        --vfs-read-chunk-size-limit off \
        --allow-other \
        --daemon \
        > "$GDRIVE_LOG_FILE" 2>&1 &
    
    # Wait for mount to complete
    sleep 2
    
    # Verify mount
    if mountpoint -q "$GDRIVE_MOUNT_POINT"; then
        echo "GDrive mounted successfully"
        df -h "$GDRIVE_MOUNT_POINT" | tail -1
    else
        echo "Mount failed. Check log: $GDRIVE_LOG_FILE"
        tail -n 10 "$GDRIVE_LOG_FILE"
        return 1
    fi
}

ungdrive() {
    if ! mountpoint -q "$GDRIVE_MOUNT_POINT"; then
        echo "GDrive is not currently mounted"
        return 1
    fi
    
    echo "Unmounting $GDRIVE_MOUNT_POINT..."
    
    # Try fusermount first (Linux)
    if command -v fusermount &> /dev/null; then
        fusermount -u "$GDRIVE_MOUNT_POINT"
    # Try umount on macOS
    elif command -v umount &> /dev/null; then
        umount "$GDRIVE_MOUNT_POINT"
    else
        echo "Error: No unmount utility found"
        return 1
    fi
    
    if [ $? -eq 0 ]; then
        echo "GDrive unmounted successfully"
    else
        echo "Unmount failed. Try: fusermount -uz $GDRIVE_MOUNT_POINT"
        return 1
    fi
}

gstatus() {
    if mountpoint -q "$GDRIVE_MOUNT_POINT"; then
        echo "Status: GDrive is mounted"
        echo "Mount point: $GDRIVE_MOUNT_POINT"
        df -h "$GDRIVE_MOUNT_POINT" | tail -1
    else
        echo "Status: GDrive is not mounted"
        echo "To mount: gdrive"
    fi
}

# ============================================================================
# BACKUP TO CLOUD (Local -> OneDrive)
# ============================================================================

backup-work() {
    echo "Backing up Work directory to OneDrive..."
    rclone copy ~/Work onedrive:Backups/Work \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

backup-config() {
    echo "Backing up Config directory to OneDrive..."
    rclone copy ~/Config onedrive:Backups/Config \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

backup-uni() {
    echo "Backing up University directory to OneDrive..."
    rclone copy ~/University onedrive:Backups/University \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

backup-personal() {
    echo "Backing up Personal directory to OneDrive..."
    rclone copy ~/Personal onedrive:Backups/Personal \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

# ============================================================================
# CLOUD SYNC (Bi-directional Sync)
# ============================================================================

sync-work() {
    echo "Syncing Work directory with OneDrive..."
    rclone sync ~/Work onedrive:Backups/Work \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

sync-config() {
    echo "Syncing Config directory with OneDrive..."
    rclone sync ~/Config onedrive:Backups/Config \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

# ============================================================================
# CLOUD MIRRORING (OneDrive -> Google Drive)
# ============================================================================

mirror-to-gdrive() {
    echo "Mirroring OneDrive backups to Google Drive..."
    rclone sync onedrive:Backups gdrive:Backups_Mirror \
        --progress \
        --log-level INFO
}

mirror-from-gdrive() {
    echo "Mirroring Google Drive backups to OneDrive..."
    rclone sync gdrive:Backups_Mirror onedrive:Backups \
        --progress \
        --log-level INFO
}

# ============================================================================
# COMBINED OPERATIONS
# ============================================================================

backup-all() {
    echo "Starting full backup to OneDrive..."
    backup-work && backup-config && backup-uni
    echo "Full backup completed"
}

cloud-sync() {
    echo "Starting cloud sync operation..."
    backup-all && mirror-to-gdrive
    echo "Cloud sync completed"
}

# ============================================================================
# PULL FROM CLOUD (Cloud -> Local)
# ============================================================================

pull-work() {
    echo "Pulling Work directory from OneDrive..."
    rclone copy onedrive:Backups/Work ~/Work \
        --progress \
        --log-level INFO
}

pull-config() {
    echo "Pulling Config directory from OneDrive..."
    rclone copy onedrive:Backups/Config ~/Config \
        --progress \
        --log-level INFO
}

pull-uni() {
    echo "Pulling University directory from OneDrive..."
    rclone copy onedrive:Backups/University ~/University \
        --progress \
        --log-level INFO
}

pull-personal() {
    echo "Pulling Personal directory from OneDrive..."
    rclone copy onedrive:Backups/Personal ~/Personal \
        --progress \
        --log-level INFO
}

# Pull from Google Drive mirror
pull-work-g() {
    echo "Pulling Work directory from Google Drive..."
    rclone copy gdrive:Backups_Mirror/Work ~/Work \
        --progress \
        --log-level INFO
}

pull-all() {
    echo "Pulling all directories from OneDrive..."
    pull-work && pull-config && pull-uni
    echo "Pull completed"
}

# ============================================================================
# SELECTIVE PROJECT OPERATIONS
# ============================================================================

pproj() {
    if [ -z "$1" ]; then
        echo "Error: Project folder name required"
        echo "Usage: pproj <project-name>"
        return 1
    fi
    
    local project_name="$1"
    echo "Pulling project: $project_name"
    
    rclone copy "onedrive:Backups/Work/Projects/$project_name" \
        "$HOME/Work/Projects/$project_name" \
        --progress \
        --log-level INFO
}

bproj() {
    if [ -z "$1" ]; then
        echo "Error: Project folder name required"
        echo "Usage: bproj <project-name>"
        return 1
    fi
    
    local project_name="$1"
    echo "Backing up project: $project_name"
    
    rclone copy "$HOME/Work/Projects/$project_name" \
        "onedrive:Backups/Work/Projects/$project_name" \
        --progress \
        --exclude-from "$EXCLUDE_FILE" \
        --log-level INFO
}

# ============================================================================
# CLOUD VERIFICATION & DIAGNOSTICS
# ============================================================================

cloud-check() {
    echo "Checking cloud storage connections..."
    echo ""
    
    echo "OneDrive:"
    if rclone about onedrive: 2>/dev/null | grep -q "Total:"; then
        echo "  Status: Connected"
        rclone about onedrive: 2>/dev/null | grep -E "Total:|Used:|Free:"
    else
        echo "  Status: Not connected or not configured"
    fi
    
    echo ""
    echo "Google Drive:"
    if rclone about gdrive: 2>/dev/null | grep -q "Total:"; then
        echo "  Status: Connected"
        rclone about gdrive: 2>/dev/null | grep -E "Total:|Used:|Free:"
    else
        echo "  Status: Not connected or not configured"
    fi
    
    echo ""
    echo "GDrive Mount:"
    gstatus
}

cloud-list() {
    local remote="${1:-onedrive}"
    local path="${2:-Backups}"
    
    echo "Listing contents of $remote:$path"
    rclone ls "$remote:$path" --max-depth 2
}

# ============================================================================
# CLOUD CLEANUP
# ============================================================================

cloud-dedupe() {
    local remote="${1:-onedrive}"
    
    if [ -z "$2" ]; then
        echo "Error: Path required"
        echo "Usage: cloud-dedupe <remote> <path>"
        echo "Example: cloud-dedupe onedrive Backups/Work"
        return 1
    fi
    
    echo "Finding duplicates in $remote:$2..."
    rclone dedupe --dedupe-mode interactive "$remote:$2"
}

# ============================================================================
# HELP COMMAND
# ============================================================================

cloud-help() {
    cat << 'EOF'
Cloud Storage Commands
======================

Google Drive Mount:
  gdrive              Mount Google Drive to ~/gdrive
  ungdrive            Unmount Google Drive
  gstatus             Check mount status

Backup (Local -> Cloud):
  backup-work         Backup Work directory
  backup-config       Backup Config directory
  backup-uni          Backup University directory
  backup-personal     Backup Personal directory
  backup-all          Backup all directories

Pull (Cloud -> Local):
  pull-work           Pull Work from OneDrive
  pull-config         Pull Config from OneDrive
  pull-uni            Pull University from OneDrive
  pull-personal       Pull Personal from OneDrive
  pull-work-g         Pull Work from Google Drive
  pull-all            Pull all from OneDrive

Project Operations:
  pproj <name>        Pull specific project
  bproj <name>        Backup specific project

Cloud Sync:
  sync-work           Bi-directional sync Work
  sync-config         Bi-directional sync Config
  mirror-to-gdrive    Mirror OneDrive -> GDrive
  mirror-from-gdrive  Mirror GDrive -> OneDrive
  cloud-sync          Full backup + mirror

Diagnostics:
  cloud-check         Check cloud connections
  cloud-list [remote] List cloud contents
  cloud-dedupe        Remove duplicates
  cloud-help          Show this help

Examples:
  gdrive                          # Mount Google Drive
  backup-all                      # Backup everything
  cloud-sync                      # Full cloud sync
  pproj my-project                # Pull specific project
  cloud-list onedrive Backups     # List OneDrive backups
EOF
}
