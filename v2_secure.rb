# winrm_shell_secure.rb
# Requisitos: gem install winrm
require 'winrm'
require 'io/console'

# Configuración: mejor desde variables de entorno
endpoint = ENV['WINRM_ENDPOINT'] || 'http://192.168.1.47:5985/wsman'
user = ENV['WINRM_USER'] || 'administrator'

# Pedir contraseña sin eco 
print "Password for #{user}: "
password = STDIN.noecho(&:gets).chomp
puts

begin
  conn = WinRM::Connection.new(
    endpoint: endpoint,
    user: user,
    password: password
    # Si usas HTTPS y certificados, configura el endpoint a https://host:5986/wsman
    # y añade opciones de ssl si es necesario.
  )

  command = nil
  conn.shell(:powershell) do |shell|
    loop do
      print "PS > "
      line = STDIN.gets
      break if line.nil? # Ctrl-D
      cmd = line.chomp
      break if cmd.downcase == 'exit'

      output = shell.run(cmd) do |stdout, stderr|
        STDOUT.print stdout
        STDERR.print stderr
      end

      puts "Exit code: #{output.exitcode}"
    end
  end
rescue Interrupt
  puts "\nInterrupted by user"
rescue => e
  warn "Error: #{e.class} - #{e.message}"
end
