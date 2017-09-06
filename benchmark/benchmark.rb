require 'csv'

require 'bundler/setup'
require 'benchmark/ips'
require 'typedcsv'
require 'faker'
require 'securerandom'

PATH = 'example.csv'

if File.exist?(PATH)
  $stderr.puts "using existing #{PATH.inspect}"
else
  $stderr.puts "generating new #{PATH.inspect}"
  File.open(PATH, 'w') do |f|
    f.puts %w{
      name
      income:number
      created_at:date
      zipcode:text
      list:list
      uuid
      quote
    }.to_csv
    (2**15).times do
      f.puts [
        Faker::Name.name,
        rand(2**16) + rand(),
        Faker::Date.backward(900),
        Faker::Address.zip_code,
        rand(5).times.map { Faker::TwinPeaks.location }.to_csv.chomp,
        SecureRandom.uuid,
        Faker::TwinPeaks.quote
      ].to_csv
    end
  end
end

Benchmark.ips do |x|
  x.report("CSV.foreach - array mode") do
    count = 0
    CSV.foreach(PATH) do |row|
      count += 1
    end
  end
  x.report("Typedcsv.foreach - array mode") do
    count = 0
    Typedcsv.foreach(PATH) do |row|
      count += 1
    end
  end
  x.report("CSV.foreach - hash mode") do
    count = 0
    CSV.foreach(PATH, headers: true) do |row|
      count += 1
    end
  end
  x.report("Typedcsv.foreach - hash mode") do
    count = 0
    Typedcsv.foreach(PATH, headers: true) do |row|
      count += 1
    end
  end
end
