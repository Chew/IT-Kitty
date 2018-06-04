require 'discordrb'
require 'rest-client'
require 'json'
require 'yaml'
require 'nokogiri'
require 'open-uri'
puts 'All dependicies loaded'

CONFIG = YAML.load_file('config.yaml')
puts 'Config loaded from file'

Bot = Discordrb::Commands::CommandBot.new token: CONFIG['token'], client_id: CONFIG['client_id'], prefix: ["<@#{CONFIG['client_id']}> ", CONFIG['prefix']]

puts 'Initial Startup complete, loading all plugins...'

Starttime = Time.now

Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each { |file| require file }

Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each do |wow|
  bob = File.readlines(wow) { |line| line.split.map(&:to_s).join }
  command = bob[0][7..bob[0].length]
  command.delete!("\n")
  command = Object.const_get(command)
  Bot.include! command
  puts "Plugin #{command} successfully loaded!"
end

puts 'Done loading plugins! Finalizing start-up'

Bot.server_create do |event|
end

Bot.server_delete do |event|
end

Bot.member_join do |event|
  bot.channel(452_890_393_286_148_097).send_embed do |embed|
    embed.title = 'User Joined the Server!'
    embed.colour = 0xd084
    embed.description = "Please welcome #{event.user.mention} to the server!"

    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Member Count: #{event.server.member_count}")
  end
end

Bot.member_leave do |event|
  bot.channel(452_890_393_286_148_097).send_embed do |embed|
    embed.title = 'User Left the Server!'
    embed.colour = 0xd084
    embed.description = "#{event.user.distinct} left! RIP :("

    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Member Count: #{event.server.member_count}")
  end
end

Bot.ready do |_event|
  Bot.game = 'mew ;3'
end

puts 'Bot is ready!'
Bot.run
