import discord
from discord.ext import commands
from dotenv import load_dotenv
import os

class MyClient(commands.Bot):
    def __init__(self):
        intents = discord.Intents.default()
        intents.message_content = True

        super().__init__(
            command_prefix="!",
            intents=intents,
            help_command=None
        )

    async def setup_hook(self):
        """
        this loops through the 'commands' folder and loads every file ending in .py
        """
        if os.path.exists('./commands'):
            for filename in os.listdir('./commands'):
                if filename.endswith('.py'):
                    try:
                        # f'commands.{filename[:-3]}' converts 'ping.py' to 'commands.ping'
                        await self.load_extension(f'commands.{filename[:-3]}')
                        print(f"Log: Loaded extension: {filename}")
                    except Exception as e:
                        print(f"Error: Failed to load extension {filename}: {e}")
        else:
            print("Error: 'commands' folder not found.")
        try:
            synced = await self.tree.sync()
            print(f"Synced {len(synced)} command(s)")
        except Exception as e:
            print(f"Failed to sync commands: {e}")

    async def on_ready(self):
        print(f'Logged on as {self.user}!')

    async def on_message(self, message):
        if message.author == self.user:
            return

        await self.process_commands(message)
        print(f'Message from {message.author}: {message.content}')

"""
class MyClient(discord.Client):
    def __init__(self, *, intents: discord.Intents):
        super().__init__(intents=intents)
        self.tree = app_commands.CommandTree(self)

    async def on_ready(self):
        print(f'Logged on as {self.user}!')
        try:
            synced = await self.tree.sync()
            print(f"Synced {len(synced)} command(s)")
        except Exception as e:
            print(f"Failed to sync commands: {e}")

    async def on_message(self, message):
        if message.author == self.user:
            return
        print(f'Message from {message.author}: {message.content}')
"""

def init():
    """
    # load_dotenv()
    # intents = discord.Intents.default()
    # intents.message_content = True
    #
    # client = MyClient(intents=intents)
    #
    # client.run(os.getenv('DISCORD_TOKEN'))
    """

    load_dotenv()
    MyClient().run(os.getenv('DISCORD_TOKEN'))

if __name__ == "__main__":
    init()