import subprocess
import sys

switch_os = subprocess.run(["nh", "os", "switch"])

if switch_os.returncode != 0:
    print("[NHO-HELPER] Trying to remove the hm files...")
    rm_cache = subprocess.run(
        ["find", "~", "-type", "f", "-name", '"*.hm_backup"', "-delete"]
    )
    if rm_cache.returncode != 0:
        print("[NHO-HELPER] There was an error removing the hm files", file=sys.stderr)
    else:
        _ = subprocess.run(["nh", "os", "switch"])
