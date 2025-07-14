#autoload
#!/bin/zsh
# Define the base directory for Obsidian notes
obsidian_base="~/Notes/700 Vaults/790 Generated Assets/"

#This sets up a function for each pattern....
# Loop through all files in the ~/.config/fabric/patterns directory
for pattern_file in ~/.config/fabric/patterns/*; do
  # Get the base name of the file (i.e., remove the directory path)
  pattern_name=$(basename "$pattern_file")

  # Unalias any existing alias with the same name
  unalias "$pattern_name" 2>/dev/null

  # Define a function dynamically for each pattern
  eval "
    $pattern_name() {
        local title=\$1
        local date_stamp=\$(date +'%Y-%m-%d')
        local output_path=\"\$obsidian_base/\${date_stamp}-\${title}.md\"

        # Check if a title was provided
        if [ -n \"\$title\" ]; then
            # If a title is provided, use the output path
            fabric --pattern \"$pattern_name\" -o \"\$output_path\"
        else
            # If no title is provided, use --stream
            fabric --pattern \"$pattern_name\" --stream
        fi
    }
    "
done
# autoload -Uz ${my_functions}/*(:t)
# The (:t) is a globbing modifier which takes the tail (basename) of all the files in the list.
