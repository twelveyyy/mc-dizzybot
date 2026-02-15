# mc-dizzybot

<div align="center">

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

![Discord.py](https://img.shields.io/badge/discord.py-blueviolet?style=for-the-badge&logo=discord&logoColor=white)

</div>

## Overview


`mc-dizzybot` is a Discord bot designed to keep your community updated on the status of your Minecraft servers.

This bot is a personal learning project.

Scripts are horrible but they work.

The project is not finished, it is extremely prone to breaking in 2 pieces.

Did I say two? Three??? Four!!??? Ehhh whatever..


## Quick Start

Follow these steps to get `mc-dizzybot` up and running in your Discord server.

### Prerequisites
-   **Python 3.8+**: Ensure you have a compatible Python version installed.
-   **Discord Bot Token**: You need to create a new application on the [Discord Developer Portal](https://discord.com/developers/applications), turn it into a bot, and obtain its token.
-   **A Minecraft Server**: 👍👍

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/twelveyyy/mc-dizzybot.git
    cd mc-dizzybot
    ```

2.  **Create a virtual environment: venv**
    ```bash
    python -m venv venv
    On Windows, use `venv\Scripts\activate`
    ```

3.  **Install dependencies**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Environment setup**
    Create a `.env` file in the root directory and add your credentials:
    ```bash
    # Open the .env file and add:
    DISCORD_TOKEN=
    MC_ANNOUNCE_SERVER_WEBHOOK_URL=
    ```

5. **Server setup**
   Enter `server/` and read the intructions.

6.  **Run the bot**
    ```bash
    python main.py
    ```
    The bot should now connect to Discord and be ready to monitor your Minecraft servers.

## 📁 Project Structure

```
mc-dizzybot/
├── .gitignore          # Specifies intentionally untracked files to ignore
├── .idea/              # IDE configuration files (e.g., PyCharm)
├── commands/           # Directory to hold individual Discord bot command modules
├── main.py             # Main entry point for the Discord bot, initializes and runs the bot
├── mc_announce.py      # Module responsible for Minecraft server opening/closing status announcements.
├── requirements.txt    # Lists Python dependencies required for the project
├── server/             # Server-related.
└── server_info.json    # Do not remove it, spaghetti codes will not work with out it
```

## Deployment

Unfortunately, as of now you have to run the bot locally; online deployment compatibility will be considered.



<div align="center">

Made with ❤️ by twelveyyy

</div>

