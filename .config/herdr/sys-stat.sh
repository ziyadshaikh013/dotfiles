#!/usr/bin/env bash
set -euo pipefail

# 1. CPU Usage (%)
if [ -r /proc/stat ]; then
  read -r _ u1 n1 s1 i1 w1 q1 r1 _ < /proc/stat
  sleep 0.15
  read -r _ u2 n2 s2 i2 w2 q2 r2 _ < /proc/stat
  idle_diff=$(( (i2 + w2) - (i1 + w1) ))
  total_diff=$(( (u2 + n2 + s2 + i2 + w2 + q2 + r2) - (u1 + n1 + s1 + i1 + w1 + q1 + r1) ))
  if [ "$total_diff" -gt 0 ]; then
    cpu=$(( 100 * (total_diff - idle_diff) / total_diff ))
    cpu_str="CPU: ${cpu}%"
  else
    cpu_str="CPU: -"
  fi
else
  cpu_str="CPU: -"
fi

# 2. RAM Usage
mem_str=$(free -m | awk '/Mem:/ { printf("RAM: %.1f/%.0fGB (%.0f%%)", $3/1024, $2/1024, ($3/$2)*100) }')

# 3. GPU Usage (NVIDIA)
gpu_str=""
if command -v nvidia-smi &>/dev/null; then
  gpu_raw=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -n1 || true)
  if [ -n "$gpu_raw" ]; then
    gpu_util=$(echo "$gpu_raw" | awk -F',' '{gsub(/ /, "", $1); print $1}')
    gpu_used=$(echo "$gpu_raw" | awk -F',' '{gsub(/ /, "", $2); printf "%.1f", $2/1024}')
    gpu_total=$(echo "$gpu_raw" | awk -F',' '{gsub(/ /, "", $3); printf "%.1f", $3/1024}')
    gpu_str=" │ GPU: ${gpu_util}% (${gpu_used}/${gpu_total}GB)"
  fi
fi

echo "${cpu_str} │ ${mem_str}${gpu_str}"
