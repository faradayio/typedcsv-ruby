require "spec_helper"
require 'tempfile'

RSpec.describe Typedcsv do
  it "wraps CSV.foreach with headers" do
    Tempfile.open('test.csv') do |f|
      f.puts "name,income:number,created_at:date,zipcode:text,list:list"
      f.puts "seamus,123.45,2017-08-30,00540,1;2;3"
      f.flush
      count = 0
      Typedcsv.foreach(f.path, headers: true) do |row|
        count += 1
        expect(row.fetch('name')).to eq('seamus')
        expect(row.fetch('income')).to eq(123.45)
        expect(row.fetch('created_at')).to eq(Date.new(2017,8,30))
        expect(row.fetch('zipcode')).to eq('00540')
        expect(row.fetch('list')).to eq(['1','2','3'])
      end
      expect(count).to eq(1)
    end
  end

  it "wraps CSV.foreach in array mode" do
    Tempfile.open('test.csv') do |f|
      f.puts "name,income:number,created_at:date,zipcode:text,list:list"
      f.puts "seamus,123.45,2017-08-30,00540,1;2;3"
      f.flush
      count = 0
      Typedcsv.foreach(f.path) do |row|
        count += 1
        expect(row[0]).to eq('seamus')
        expect(row[1]).to eq(123.45)
        expect(row[2]).to eq(Date.new(2017,8,30))
        expect(row[3]).to eq('00540')
        expect(row[4]).to eq(['1','2','3'])
      end
      expect(count).to eq(1)
    end
  end
end
