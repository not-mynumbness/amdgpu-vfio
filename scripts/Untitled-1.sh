#!/bin/bash

# Check if any drivers are in use
check_drivers() {
  if [ ${#DRIVERS[@]} -gt 0 ]; then
    declare -A driver_count

    for driver in "${DRIVERS[@]}"; do
      driver_name=$(get_driver_name "$driver")
      driver_count["$driver_name"]=$((driver_count["$driver_name"] + 1))
    done

    for driver_name in "${!driver_count[@]}"; do
      echo "Driver: $driver_name, Count: ${driver_count[$driver_name]}"
    done

    if [ $((${#driver_count[@]})) -eq 1 ]; then
      # Perform action for a single driver
      echo "Only one driver found, performing action for single driver"
    else
      for driver_name in "${!driver_count[@]}"; do
        if [ ${driver_count[$driver_name]} -gt 1 ]; then
          echo "Multiple drivers found, performing action for different drivers"
          # Perform action for different drivers
          bash $HOME/.local/share/amdgpu-vfio/scripts/vfio_add_new_id
          break
        else
          echo "Only one driver found, performing action for single driver"
          # Perform action for a single driver
          bash $HOME/.local/share/amdgpu-vfio/scripts/amdgpu_snd_hda_intel_add_new_id
        fi
      done
    fi
  fi
}
e
# Extract driver name from the full path
get_driver_name() {
  echo "${1##*/}" | awk -F . '{print $1}'
}

# Example usage of the check_drivers function
DRIVERS=(/usr/lib/modules/5.13.0-30-generic/kernel/drivers/gpu/drm/amd/amdgpu.ko /usr/lib/modules/5.13.0-30-generic/kernel/drivers/gpu/drm/i915/i915.ko)
check_drivers
