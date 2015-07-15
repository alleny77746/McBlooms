namespace :deploy do
  namespace :web do
    task :disable_robots, :roles => :app do
      puts "*** Disabling Robots ***"
      puts "         [@@]  "
      puts "        /|__|\\ "
      puts "         d  b   "

      robots_txt = <<-EOF
User-agent: *
Disallow: /
EOF

      if !production? || agree("Are you sure you want to overwrite robots.txt in #{environment}?")
        put robots_txt, "#{current_path}/public/robots.txt"
      end
    end
  end
end
after 'deploy:create_symlink', 'deploy:web:disable_robots'