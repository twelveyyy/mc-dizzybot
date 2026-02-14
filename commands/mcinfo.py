import discord
from discord import app_commands
from discord.ext import commands
import json
import os

INFO_FILE = "server_info.json"

class CopyView(discord.ui.View):
    def __init__(self, full_address: str):
        super().__init__(timeout=None)
        self.full_address = full_address

    @discord.ui.button(label="Display address", style=discord.ButtonStyle.secondary, emoji="📋")
    async def copy_button(self, interaction: discord.Interaction, button: discord.ui.Button):
        await interaction.response.send_message(f"`{self.full_address}`", ephemeral=True)

class Minecraft(commands.Cog):
    def __init__(self, bot: commands.Bot):
        self.bot = bot

    def get_server_info(self):
        if not os.path.exists(INFO_FILE):
            return None
        try:
            with open(INFO_FILE, "r") as f:
                return json.load(f)
        except:
            return None

    @app_commands.command(name="mcinfo", description="Get Minecraft server status")
    async def info(self, interaction: discord.Interaction):
        data = self.get_server_info()
        if not data:
            embed = discord.Embed(
                title="🌍 Minecraft Server Info",
                color=discord.Color.red()
            )
            embed.add_field(name="Status", value="🔴 Offline", inline=False)
            await interaction.response.send_message(embed=embed)
            return

        embed = discord.Embed(title="🌍 Minecraft Server Info", color=discord.Color.green())
        embed.add_field(name="Status", value="🟢 Online", inline=False)
        embed.add_field(name="Server Name", value=data.get('name'), inline=False)
        full_address = f"[{data.get('ip')}]:{data.get('port')}"
        embed.add_field(name="🔗 Connection Address", value=f"`{full_address}`", inline=False)
        embed.add_field(name="IPv6 Address", value=data.get('ip'), inline=True)
        embed.add_field(name="Port", value=data.get('port'), inline=True)
        embed.set_footer(text=f"Last Started: {data.get('date')}")

        await interaction.response.send_message(embed=embed, view=CopyView(full_address))


async def setup(bot: commands.Bot):
    await bot.add_cog(Minecraft(bot))