function game-on
    sudo tlp ac
    echo performance | sudo tee /sys/firmware/acpi/platform_profile
    if test -e /sys/devices/platform/thinkpad_acpi/platform-profile/platform-profile-0/profile
        echo performance | sudo tee /sys/devices/platform/thinkpad_acpi/platform-profile/platform-profile-0/profile
    end
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    echo high | sudo tee /sys/class/drm/card1/device/power_dpm_force_performance_level
    if test -r /sys/module/thinkpad_acpi/parameters/fan_control
        if test (cat /sys/module/thinkpad_acpi/parameters/fan_control) = Y
            sudo install -Dm644 ~/.config/thinkfan/thinkfan-game.yaml /etc/thinkfan.yaml
            sudo systemctl restart thinkfan.service
            echo "fan profile: thinkfan game curve enabled"
        else
            echo "fan profile: thinkpad fan_control is disabled, skipped"
            echo "hint: reload thinkpad_acpi with fan_control=1 or reboot after installing thinkfan"
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

    if test "$lapmode" = 1
        echo "warning: thinkpad dytc_lapmode=1, firmware may clamp CPU near 400 MHz"
    end

    echo "game profile: on"
end
