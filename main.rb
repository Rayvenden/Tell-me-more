#!/usr/bin/ruby

require 'getoptlong'
require 'etc'

opts = GetoptLong.new(
    [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
    [ '--memory', '-m', GetoptLong::NO_ARGUMENT ],
    [ '--whoami', '-w', GetoptLong::NO_ARGUMENT ],
    [ '--users', '-u', GetoptLong::NO_ARGUMENT],
    [ '--no-bash', '-n', GetoptLong::NO_ARGUMENT ],
    [ '--uptime', '-t', GetoptLong::OPTIONAL_ARGUMENT ]
)

begin
    opts.each do |opt, arg|
        case opt
            when '--help'
                puts <<-EOF
Tell-me-more

Arguments:
-h, --help:
    show help
-m, --memory:
    show information about memory
-w, --whoami:
    show user's name
-u, --users:
    show users with Bash as login shell
-n, --no-bash:
    show users not using Bash as login shell, excluding users
    with nologin and false as shells
-t, --uptime:
    show system uptime. I takes additional argument 'm' or 'h' to format
    output as minutes or hours
                EOF
                break
            when '--memory'
                File.open('/proc/meminfo', 'r') do |file|
                    file.each_line do |line|
                        if /^Mem/ =~ line
                            puts "#{line.split(':')[0]}: "+
                                "#{line.split()[1].to_i / 1024} MB"
                        end
                    end
                end
                break
            when '--whoami'
                puts Etc.getlogin
                break
            when '--users'
                File.open('/etc/passwd', 'r') do |file|
                    file.each_line do |line|
                        puts line.split(':')[0] if /\/bash/ =~ line
                    end
                end
                break
            when '--no-bash'
                File.open('/etc/passwd', 'r') do |file|
                    file.each_line do |line|
                        puts line.split(':')[0] unless
                            /\/bash|\/nologin|\/false/ =~ line
                    end
                end
                break
            when '--uptime'
                File.open('/proc/uptime') do |file|
                    if arg == 'm' or arg == ''
                        puts "#{(file.readline.split[0].to_f / 60).round(2)}"+
                            " minutes."
                    elsif arg == 'h'
                        puts "#{(file.readline.split[0].to_f / 3600).round(2)}"+
                            " hours"
                    else
                        puts "Wrong --uptime parameter."
                    end
                end
                break
        end
    end
# ignore exceptions, because GetoptLong displays error messages anyway
rescue GetoptLong::Error
end
