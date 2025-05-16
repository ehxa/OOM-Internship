#!/bin/bash
# Geekbench 6 CPU scores
# Adapted from oleglegun/geekbench-avg-scores using DeepSeek

if [ $# -eq 0 ]; then
  echo "Usage: $0 <query>"
  exit 1
fi

query="$*"
max_pages=100  
delay=1      

echo "Searching Geekbench 6 for: $query"

single_scores=()
multi_scores=()
total_results=0
pages_with_results=0

for ((page=1; page<=max_pages; page++)); do
  echo -n "Checking page $page... "
  
  content=$(curl -s "https://browser.geekbench.com/search?page=$page&q=$(echo "$query" | sed 's/ /+/g')")
  
  if echo "$content" | grep -q "did not match any Geekbench results"; then
    echo "no more results"
    break
  fi
  
  page_scores=$(echo "$content" | grep -A 1 "list-col-text-score" | grep -oE '[0-9]+')
  count=$(echo "$page_scores" | wc -w)
  
  if [ $count -eq 0 ]; then
    echo "no scores found"
    continue
  fi
  
  position=1
  while read -r score; do
    if [ $((position % 2)) -eq 1 ]; then
      single_scores+=("$score")
    else
      multi_scores+=("$score")
    fi
    ((position++))
  done <<< "$page_scores"
  
  results_on_page=$((count/2))
  echo "found $results_on_page results"
  total_results=$((total_results + results_on_page))
  ((pages_with_results++))
  
  sleep $delay
done

echo 

if [ ${#single_scores[@]} -gt 0 ]; then
  sum_single=0
  for s in "${single_scores[@]}"; do
    sum_single=$((sum_single + s))
  done
  avg_single=$((sum_single / ${#single_scores[@]}))
  
  sum_multi=0
  for s in "${multi_scores[@]}"; do
    sum_multi=$((sum_multi + s))
  done
  avg_multi=$((sum_multi / ${#multi_scores[@]}))

  echo "=== Final Results ==="
  echo "Pages with results: $pages_with_results"
  echo "Total samples found: $total_results"
  echo
  echo "Single-Core Scores:"
  echo "  Average: $avg_single"
  echo "  Samples: ${#single_scores[@]}"
  echo "  Min: $(printf '%s\n' "${single_scores[@]}" | sort -n | head -1)"
  echo "  Max: $(printf '%s\n' "${single_scores[@]}" | sort -n | tail -1)"
  
  echo
  echo "Multi-Core Scores:"
  echo "  Average: $avg_multi"
  echo "  Samples: ${#multi_scores[@]}"
  echo "  Min: $(printf '%s\n' "${multi_scores[@]}" | sort -n | head -1)"
  echo "  Max: $(printf '%s\n' "${multi_scores[@]}" | sort -n | tail -1)"
else
  echo "No valid results found for '$query' after checking $max_pages pages"
fi