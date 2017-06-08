#!/opt/chefdk/embedded/bin/ruby
require 'ruby-cheerio'
require 'rest-client'
require	'terminal-notifier'
require 'colorize'

$base_ceiling=47.50

def typecast_color(log_type)
	if log_type =~ /error/i
		return log_type.upcase.red
	else
		return log_type.upcase.cyan
	end
end

def print_info(message, log_type="info")
	# puts "#{Time.now.strftime("%d/%b/%Y-%T")} - " + typecast_color(log_type) + ": " + message
	puts "#{Time.now.strftime("%d/%b/%Y - %r")} - " + typecast_color(log_type) + ": " + message
end

def help
	print_info("Following is the way arguments are specified while running the script:".cyan)
	print_info("To execute dbs_sgd_to_inr, please run: ".yellow + "ruby dbs_sgd_to_inr.rb --CEILING=46.74".red)
end

def exit_success
	help
	exit 0
end

def exit_error
	help
	exit 1
end

# The notifier function
def notify(title, date, time, message)
	t = {:title => title}
	s = {:subtitle => "at " + date + " " + time}
	m = message
	TerminalNotifier.notify(m, t.merge(s))
end

def get_response()
	response = (RestClient.get "http://www.dbs.com.sg/personal/rates-online/foreign-currency-foreign-exchange.page").to_str
	return RubyCheerio.new(response)	
end

def get_datetime(response)
	date, time = nil
	response.find('.fxtitle').each do |head_one|
		# puts head_one.html
		output = RubyCheerio.new(head_one.html).find(".span12")[0].text.delete(" \t\r").strip.split("\n\n")
		date = output[1].delete("\n")
		time = output[3]
	end
	return date, time
end

def get_exchange(response)
	exchange_rate = nil
	response.find('.filter_Indian_Rupee').each do |head_one|
		exchange_rate = RubyCheerio.new(head_one.html).find(".column-3")[0].text
	end
	return (100/exchange_rate.to_f).round(4), exchange_rate
end

def init_ceiling(ceiling=$base_ceiling)
	help
	print_info("Executing with ceiling as #{ceiling} by default".colorize(:color => :red, :mode => :bold), "info")
	return ceiling
end

def get_ceiling(argv)
	ceiling = nil
	if argv.size != 1
		print_info("Arguments passed #{argv.size} for 1".colorize(:color => :red, :mode => :bold), "error")
	elsif argv[0] =~ /help/i
		exit_success
	elsif argv[0].split("=")[0] =~ /ceiling/i
		value = argv[0].split("=")[1]
		if value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
			ceiling = value.to_f
		else
			print_info("Ceiling Amount passed is a String. Please pass the correct ceiling amount in float type".colorize(:color => :red, :mode => :bold), "error")
		end
	else
		print_info("Ceiling Argument is missing!!!".colorize(:color => :red, :mode => :bold), "error")
	end
	return (ceiling.nil?)? init_ceiling : ceiling
end

def execute(response, ceiling)
	date, time = get_datetime(response)
	message, exchange_rate  = get_exchange(response)
	print_info("SGD Exchange rate now per 100 INR - #{exchange_rate}".colorize(:color => :yellow, :mode => :bold))
	print_info("INR Exchange rate now per 1 SGD - #{message}".colorize(:color => :yellow, :mode => :bold))
	if message >= ceiling.to_f
		notify(title    = "Transfer as DBS Exchange Rate increased",
			date = date,
			time = time,
			message = message.to_s
			)
	else
		print_info("Not the Right Time to transfer".colorize(:color => :red, :mode => :blink))
	end	
end

# ARGV.each do |arg|
# 	($ceiling = arg.split("=")[1].to_s.downcase) if arg.split("=")[0] =~ /ceiling/i
# end

argv = ARGV.map! { |l| l.downcase }
execute(get_response, get_ceiling(argv))