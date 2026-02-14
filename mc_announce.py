import requests
import json
import datetime
import sys
import os

# --- CONFIGURATION ---
WEBHOOK_URL = "https://discord.com/api/webhooks/1472266530870919273/7Nzk1TyXRic39E2-rjp-K5As8MIO_TveIxGokmToVGiaFTNcPTn6Moa2p4Yb1iEU5Ykl"
FILE_NAME = "server_info.json"
# ---------------------

# Usage: python mc_announce.py on/off Name IPv6 Port

def run():
    mode = sys.argv[1].lower() if len(sys.argv) > 1 else "on"
    current_time = datetime.datetime.now()
    time_ran_str = ""

    if mode == "on":
        # Argument Mapping:
        # sys.argv[2] = Name
        # sys.argv[3] = IPv6
        # sys.argv[4] = Port
        s_name = sys.argv[2] if len(sys.argv) > 2 else "NULL"
        s_ipv6 = sys.argv[3] if len(sys.argv) > 3 else "NULL"
        s_port = sys.argv[4] if len(sys.argv) > 4 else "NULL"

        data = {
            "status": "online",
            "name": s_name,
            "ip": s_ipv6,
            "port": s_port,
            "date": current_time.strftime("%Y-%m-%d %H:%M:%S")
        }

        # Write to file
        with open(FILE_NAME, "w") as f:
            json.dump(data, f, indent=4)

        color = 5763719  # Green
        title = "🟢 Server Starting!"
        desc_text = f"**{data['name']}** is now coming online."
        footer_text = f"Started at: {data['date']}"

    else:
        # SIGNAL: OFF
        if os.path.exists(FILE_NAME) and os.path.getsize(FILE_NAME) > 0:
            try:
                with open(FILE_NAME, "r") as f:
                    old_data = json.load(f)
                    start_str = old_data.get("date")
                    if start_str:
                        start_dt = datetime.datetime.strptime(start_str, "%Y-%m-%d %H:%M:%S")
                        duration = current_time - start_dt

                        # Format duration: Days, Hours, Minutes
                        days = duration.days
                        hours, rem = divmod(duration.seconds, 3600)
                        minutes, seconds = divmod(rem, 60)

                        time_ran_str = f" | Total Session: "
                        if days > 0: time_ran_str += f"{days}d "
                        time_ran_str += f"{hours}h {minutes}m {seconds}s"
            except Exception as e:
                print(f"Error calculating duration: {e}")

        # empty the file
        open(FILE_NAME, "w").close()

        color = 15548997  # Red
        title = "🔴 Server Stopping"
        desc_text = "The Minecraft server has been shut down."
        footer_text = f"Stopped at: {current_time.strftime('%H:%M:%S')}{time_ran_str}"

    # Send Webhook
    if WEBHOOK_URL:
        embed = {
            "title": title,
            "description": desc_text,
            "color": color,
            "footer": {"text": footer_text}
        }
        if mode == "on":
            embed["fields"] = [
                {"name": "Address", "value": f"`[{data['ip']}]:{data['port']}`", "inline": False}
            ]
        requests.post(WEBHOOK_URL, json={"embeds": [embed]})

if __name__ == "__main__":
    run()