# Assuming input.txt contains your list of paths
input_file="input.txt"

# Loop through each line in the input file
while IFS= read -r line; do
    # Extract the filename from the path
    filename=$(basename "$line")

    # Create a new .txt file with the full path as content
    echo "$line" > "${filename}.txt"
done < "$input_file"
