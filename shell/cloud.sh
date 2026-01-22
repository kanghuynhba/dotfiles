#!/bin/bash
# ============================================================================
# Cloud Storage Management (rclone & Google Drive)
# ============================================================================

# Exclude file for backups
EXCLUDE_FILE="~/rclone-exclude.txt"

# ============================================================================
# GOOGLE DRIVE MOUNT
# ============================================================================

gdrive() {
    # Check if mount point exists
    if [ ! -d "$HOME/gdrive" ]; then
        echo "Creating mount point: ~/gdrive"
        mkdir -p "$HOME/gdrive"
    fi

    # Check if already mounted
    if mountpoint -q "$HOME/gdrive"; then
        echo "GDrive is already mounted"
        return 0
    fi

    echo "Mounting gdrive to ~/gdrive..."
    nohup rclone mount gdrive: ~/gdrive \
        --vfs-cache-mode writes \
        --vfs-cache-max-age 72h \
        --vfs-read-chunk-size 128M \
        --vfs-read-chunk-size-limit off \
        > ~/gdrive_mount.log 2>&1 &
    
    sleep 2
    
    if mountpoint -q "$HOME/gdrive"; then
        echo "GDrive mounted successfully"
    else
        echo "Mount failed. Check: ~/gdrive_mount.log"
        tail -n 10 ~/gdrive_mount.log
    fi
}

ungdrive() {
    if ! mountpoint -q "$HOME/gdrive"; then
        echo "GDrive is not mounted"
        return 1
    fi
    
    echo "Unmounting ~/gdrive..."
    fusermount -u ~/gdrive
    
    if [ $? -eq 0 ]; then
        echo "GDrive unmounted successfully"
    else
        echo "Unmount failed"
    fi
}

gstatus() {
    if mountpoint -q "$HOME/gdrive"; then
        echo "GDrive is mounted"
        df -h ~/gdrive | tail -1
    else
        echo "GDrive is not mounted"
    fi
}

# ============================================================================
# BACKUP TO CLOUD (Local -> OneDrive)
# ============================================================================

alias backup-work='rclone copy ~/Work onedrive:Backups/Work --progress --exclude-from $EXCLUDE_FILE'
alias backup-config='rclone copy ~/Config onedrive:Backups/Config --progress --exclude-from $EXCLUDE_FILE'
alias backup-uni='rclone copy ~/University onedrive:Backups/University --progress --exclude-from $EXCLUDE_FILE'

# ============================================================================
# CLOUD MIRRORING (OneDrive -> Google Drive)
# ============================================================================

alias mirror-to-gdrive='rclone sync onedrive:Backups gdrive:Backups_Mirror --progress'

# ============================================================================
# COMBINED OPERATIONS
# ============================================================================

alias backup-all='backup-work && backup-config && backup-uni'
alias cloud-sync='backup-all && mirror-to-gdrive'

# ============================================================================
# PULL FROM CLOUD (Cloud -> Local)
# ============================================================================

# Pull from OneDrive
alias pull-work='rclone copy onedrive:Backups/Work ~/Work --progress'
alias pull-config='rclone copy onedrive:Backups/Config ~/Config --progress'
alias pull-uni='rclone copy onedrive:Backups/University ~/University --progress'

# Pull from Google Drive
alias pull-work-g='rclone copy gdrive:Backups_Mirror/Work ~/Work --progress'

# ============================================================================
# SELECTIVE PROJECT PULL
# ============================================================================

pproj() {
    if [ -z "$1" ]; then
        echo "Error: Project folder name required"
        echo "Usage: pproj <project-name>"
        return 1
    fi
    
    rclone copy onedrive:Backups/Work/Projects/"$1" ~/Work/Projects/"$1" --progress
}
