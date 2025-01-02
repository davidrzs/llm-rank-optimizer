!/bin/bash

declare -A catalog_types
catalog_types=(
    ["coffee_machines"]="default"
    ["cameras"]="default"
    ["books"]="default"
    ["election_articles"]="default"
    ["election_articles_incognito"]="default custom"
)

modes=("self" "transfer")

for catalog in "${!catalog_types[@]}"; do
    read -ra types <<< "${catalog_types[$catalog]}"
    
    for mode in "${modes[@]}"; do
        for type in "${types[@]}"; do
            path="results/$catalog/$mode/$type"
            if [ -d "$path" ]; then
                echo "Running: python3 plot/aggregate_advantage.py \"$path\""
                python3 plot/aggregate_advantage.py "$path"
            else
                echo "Warning: Directory $path does not exist, skipping..."
            fi
        done
    done
done

python3 plot/metrics.py results