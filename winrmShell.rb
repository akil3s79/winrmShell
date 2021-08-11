#For use this script, you only need to install winrm on Ruby (gem install winrm).
#Execute:
#ruby winrmShell.rb

require 'winrm'

conn = WinRM::Connection.new(
  endpoint: 'http://192.168.1.47:5985/wsman',
  user: 'administrator',
  password: 'culo123',
)

command=""

conn.shell(:powershell) do |shell|
    until command == "exit\n" do
        print "PS > "
        command = gets
        output = shell.run(command) do |stdout, stderr|
            STDOUT.print stdout
            STDERR.print stderr
        end
    end
    puts "Exiting with code #{output.exitcode}"
end
