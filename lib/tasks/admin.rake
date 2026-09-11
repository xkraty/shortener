namespace :admin do
  desc "Grant admin on an existing account, or create one (prompts for a password)"
  task promote: :environment do
    require "io/console"

    email = ENV["EMAIL"].presence || begin
      print "Email: "
      $stdin.gets.to_s.strip
    end

    user = User.find_or_initialize_by(email_address: email)

    unless user.persisted?
      # Read without echoing, and never from ENV: a password in ENV lands in
      # the shell history and in the process list.
      password = $stdin.getpass("Password (min 12 characters): ")
      confirmation = $stdin.getpass("Confirm: ")

      abort "Passwords didn't match." unless password == confirmation

      user.password = password
    end

    user.admin = true

    if user.save
      puts "#{user.email_address} is now an admin."
    else
      abort user.errors.full_messages.join("\n")
    end
  end
end
