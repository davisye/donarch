function game-off
    echo auto | sudo tee /sys/class/drm/card1/device/power_dpm_force_performance_level
    echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    echo balanced | sudo tee /sys/firmware/acpi/platform_profile
    if test -e /sys/devices/platform/thinkpad_acpi/platform-profile/platform-profile-0/profile
        echo balanced | sudo tee /sys/devices/platform/thinkpad_acpi/platform-profile/platform-profile-0/profile
    end
    sudo tlp start
    if test -r /sys/module/thinkpad_acpi/parameters/fan_control
        if test (cat /sys/module/thinkpad_acpi/parameters/fan_control) = Y
            sudo systemctl stop thinkfan.service
            echo level auto | sudo tee /proc/acpi/ibm/fan >/dev/null
            echo "fan profile: firmware auto"
        else
            echo "fan profile: thinkpad fan_control is disabled, skipped"
        end
    else
        echo "fan profile: thinkpad fan interface not found, skipped"
    end

    set -l profile unknown
    if test -r /sys/firmware/acpi/platform_profile
        set profile (cat /sys/firmware/acpi/platform_profile)
    end

    set -l thinkpad_profile unknown
    if test -r /sys/devices/platform/thinkpad_acpi/platform-profile/platform-profile-0/profile
        set thinkpad_profile (cat /sys/devices/platform/thinkpad_acpi/platform-profile/platform-profile-0/profile)
    end

    set -l lapmode unknown
    if test -r /sys/devices/platform/thinkpad_acpi/dytc_lapmode
        set lapmode (cat /sys/devices/platform/thinkpad_acpi/dytc_lapmode)
    end

    set -l cpu_mhz unknown
    if test -r /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq
        set cpu_mhz (awk '{ printf "%.0f", $1 / 1000 }' /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq)
    end

    echo "status: platform=$profile thinkpad_profile=$thinkpad_profile lapmode=$lapmode cpu0=$cpu_mhz MHz"
    if test -r /proc/acpi/ibm/fan
        string match -r '^(speed|level):.*' (cat /proc/acpi/ibm/fan)
    end

    echo "game profile: off"
end
