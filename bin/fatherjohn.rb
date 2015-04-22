module MenOfFolk
  require 'rubygems'
  require 'chatterbot/dsl'
  # # require 'date'

  module_function

  # Set up credentials for @FatherJohnBot twitter app.
  # Use a yml file in development, and a Heroku's
  # ENV in production.
  CREDS = if File.exists?('fatherjohn.yml')
            puts "Reading config from fatherjohn.yml"

            YAML.load_file('fatherjohn.yml')
          else
            ENV
          end

  consumer_key CREDS['consumer_key']
  consumer_secret CREDS['consumer_secret']
  secret CREDS['secret']
  token CREDS['token']

  puts client.inspect

  # If provided, tweet one in every FREQUENCY times
  # the script is executed.
  FREQUENCY = ARGV[0] ? ARGV[0].to_i : nil

  # Don't perform public actions in test mode.
  TEST_MODE = ARGV[1] == 'test'


  def run(opts={})
    frequency = FREQUENCY || opts[:frequency] || 20
    test_mode = TEST_MODE || opts[:testing]
    its_daytime = (7..23).cover?(Time.now.getlocal("-04:00").hour)

    if rand(frequency) == 0
      if its_daytime || test_mode
        text = "#{get_intro} #{get_accolade}, #{get_title} #{get_name} #{get_weather}."
        client.update(text) unless test_mode
        text
      end
    end

  end

  %w{intro accolade title name weather}.each do |word_type|
    define_singleton_method('get_' + word_type) do
      random_line("data/#{word_type}s.txt").strip
    end
  end

  def random_line(file_path)
    File.readlines(file_path).sample.delete("\n")
  end


end

MenOfFolk.run