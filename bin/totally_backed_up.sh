#!/usr/bin/env zsh

# totally_backed_up.sh - Create an encrypted sparsebundle backup of critical files
# not covered by yadm (secrets, keychains, preferences, fonts, etc.)
#
# Usage:
#   totally_backed_up.sh                  # prompted to select destination
#   totally_backed_up.sh /path/to/dest    # use specified destination directory
#
# Options reference:
#   -[no]atomic   copy files to a temp location then rename (atomic is default)
#   -volname      filesystem label for the created image

function select_destination() {
  local icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Archives/Backups"
  local -a candidates

  [[ -d "$icloud" ]] && candidates+=("$icloud")

  # Include any mounted external volumes (excluding the boot drive)
  for vol in /Volumes/*(N/); do
    [[ "$vol" == "/Volumes/Macintosh HD" ]] && continue
    candidates+=("$vol")
  done

  # Local fallback
  candidates+=("$HOME/Backups")

  if command -v fzf &>/dev/null; then
    printf '%s\n' "${candidates[@]}" | fzf --prompt="Select backup destination: "
  else
    PS3="Select backup destination: "
    select dest in "${candidates[@]}"; do
      [[ -n "$dest" ]] && echo "$dest" && return 0
    done
  fi
}

function main() {
  local Date VolumeName Backups Archive

  Date=$(date -I)
  VolumeName="Totally_Backed_Up-${Date}"

  if [[ -n "$1" ]]; then
    Backups="$1"
  else
    Backups=$(select_destination) || { echo "No destination selected, aborting."; exit 1 }
  fi

  [[ -n "$Backups" ]] || { echo "No destination selected, aborting."; exit 1 }

  if [[ ! -d "$Backups" ]]; then
    echo "Creating backup directory: $Backups"
    mkdir -p "$Backups" || { echo "Failed to create $Backups"; exit 1 }
  fi

  Archive="${Backups}/${VolumeName}.sparsebundle"

  if [[ -e "$Archive" ]]; then
    echo "Archive already exists: $Archive"
    echo "Remove it first or choose a different destination."
    exit 1
  fi

  echo "Backup will be created at: ${Archive}"

  hdiutil create -volname "${VolumeName}" -format UDSB \
    -fs HFS+ \
    -encryption \
    "${Archive}" \
    -verbose -noatomic -skipunreadable -spotlight \
    -srcfolder ~/.gnupg \
    -srcfolder ~/.ssh \
    -srcfolder ~/.aws \
    -srcfolder ~/.kube \
    -srcfolder ~/.config \
    -srcfolder ~/Library/Audio \
    -srcfolder ~/Library/ColorPickers \
    -srcfolder ~/Library/Colors \
    -srcfolder ~/Library/FontCollections \
    -srcfolder ~/Library/Fonts \
    -srcfolder ~/Library/Keychains \
    -srcfolder ~/Library/Preferences \
    -srcfolder ~/Library/QuickLook \
    -srcfolder ~/Library/Screen\ Savers \
    -srcfolder ~/Library/Services \
    -srcfolder ~/Library/Sounds

  # Uncomment to include larger directories:
  # -srcfolder ~/Documents \
  # -srcfolder ~/Downloads \
  # -srcfolder ~/Repositories \
  # -srcfolder ~/Library/Application\ Support \

  echo "Verifying backup..."
  if [[ -d "${Archive}" ]]; then
    local size
    size=$(du -sh "${Archive}" | cut -f1)
    echo "✅ Backup created: ${Archive} (${size})"
  else
    echo "❌ Archive not found after creation: ${Archive}"
    exit 1
  fi
}

main "$@"
