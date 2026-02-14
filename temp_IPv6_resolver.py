import subprocess
import re
import platform

def get_temporary_ipv6():
    system = platform.system()

    try:
        if system == "Windows":
            # Run ipconfig
            result = subprocess.run(["ipconfig"], capture_output=True, text=True)
            output = result.stdout
            pattern = r"Temporary IPv6 Address[ .]*: ([a-fA-F0-9:]+)"
            match = re.search(pattern, output)
            if match:
                return match.group(1)

        elif system == "Linux":
            # Run ip addr show
            result = subprocess.run(["ip", "-6", "addr", "show"], capture_output=True, text=True)
            output = result.stdout
            pattern = r"inet6 ([a-fA-F0-9:]+)/[0-9]+ scope global temporary"
            match = re.search(pattern, output)
            if match:
                return match.group(1)

    except Exception as e:
        print(f"Error retrieving IPv6: {e}")
        return None

    return None