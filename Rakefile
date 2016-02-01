task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/modsearch.zip doc/modsearch.txt autoload/ plugin/'
end
