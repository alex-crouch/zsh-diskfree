# diskfree plugin for oh-my-zsh
# Original Author: Alex Crouch (alex-crouch)

# Load configuration from file
function load_diskfree_config() {
    local config_file="$ZSH_CUSTOM/plugins/zsh-diskfree/zsh-diskfree.conf"
    
    # Temporary variables for config values
    local UNIT_FORMAT=4
    local UNIT_GAP=0
    local SHOW_ICON=0
    local ALL_DISKS=0
    
    # Load from config file if it exists
    if [[ -f "$config_file" ]]; then
        # Use different variable names in config file
        # local UNIT_FORMAT UNIT_GAP SHOW_ICON ALL_DISKS
        source "$config_file"
    fi
    
    # Set values, using environment variables if set, otherwise config values, otherwise defaults
    typeset -g ZSH_DISKFREE_UNIT_FORMAT=${ZSH_DISKFREE_UNIT_FORMAT:-$UNIT_FORMAT}
    typeset -g ZSH_DISKFREE_UNIT_GAP=${ZSH_DISKFREE_UNIT_GAP:-$UNIT_GAP}
    typeset -g ZSH_DISKFREE_SHOW_ICON=${ZSH_DISKFREE_SHOW_ICON:-$SHOW_ICON}
    typeset -g ZSH_DISKFREE_ALL_DISKS=${ZSH_DISKFREE_ALL_DISKS:-$ALL_DISKS}
}

# Load configuration
load_diskfree_config

# Get free disk space of current disk
function raw_free_disk() {
    local free_bytes
    free_bytes=$(df . | awk 'NR==2 {print $4}')
    echo "$free_bytes"
}

# Get free disk space of all disks
function total_raw_free_disk() {
    local free_bytes
    free_bytes=$(df | awk 'NR>1 {sum += $4} END {print sum}')
    echo "$free_bytes"
}

function display_format() {
    local bytes=$1

    # Define unit formats
    local -a units

    case $ZSH_DISKFREE_UNIT_FORMAT in
        1) units=("" "K" "M" "G" "T" "P" "E" "Z" "Y") ;;
        2) units=("" "KB" "MB" "GB" "TB" "PB" "EB" "ZB" "YB") ;;
        3) units=("" "ᴷᴮ" "ᴹᴮ" "ᴳᴮ" "ᵀᴮ" "ᴾᴮ" "ᴱᴮ" "ᶻᴮ" "ʸᴮ") ;;
        *) units=("" "ᴷ" "ᴹ" "ᴳ" "ᵀ" "ᴾ" "ᴱ" "ᶻ" "ʸ") ;;
    esac

    local i=2
    
    # Handle large numbers by removing digits in groups of 3
    while [[ ${#bytes} -gt 3 && $i -lt ${#units[@]} ]]; do
        bytes=${bytes%???}
        ((i++))
    done
    
    # Print the result with the appropriate unit and unit gap
    if [[ $ZSH_DISKFREE_UNIT_GAP -eq 1 ]]; then
        echo "$bytes ${units[$i]} "
    else
        echo "$bytes${units[$i]}"
    fi
}

# Add disk usage to prompt
function diskfree_prompt_info() {
    local free_bytes free_space
    # Show or hide disk icon
    if [[ $ZSH_DISKFREE_ALL_DISKS -eq 1 ]]; then
        free_bytes=$(total_raw_free_disk)
    else
        free_bytes=$(raw_free_disk)
    fi

    free_space=$(display_format $free_bytes)

    # Show or hide disk icon
    if [[ $ZSH_DISKFREE_SHOW_ICON -eq 1 ]]; then
        echo "%{$fg[cyan]%}💾 $free_space%{$reset_color%}"
    else
        echo "%{$fg[cyan]%}$free_space%{$reset_color%}"
    fi
}