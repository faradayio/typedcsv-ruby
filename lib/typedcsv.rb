require 'typedcsv/version'

require 'csv'
require 'date'
require 'time'

class Typedcsv
  def Typedcsv.foreach(*args, &blk)
    typedcsv = new(*args, &blk)
    if args.last.is_a?(Hash) and args.last[:headers]
      typedcsv.foreach_hash
    else
      typedcsv.foreach_array
    end
  end

  attr_reader :args
  attr_reader :blk

  def initialize(*args, &blk)
    @args = args
    @blk = blk
  end

  def foreach_hash
    headers = nil
    CSV.foreach(*args) do |row|
      unless headers
        headers = Headers.new(row.headers)
      end
      blk.call headers.parse_hash(row)
    end
  end

  def foreach_array
    headers = nil
    CSV.foreach(*args) do |row|
      unless headers
        headers = Headers.new(row)
        next
      end
      blk.call headers.parse_array(row)
    end
  end

  class Headers
    attr_reader :raw
    def initialize(raw)
      @raw = raw
    end
    def types
      @types ||= raw.each_with_index.map do |raw_k, i|
        k, type = raw_k.split(':', 2)
        if type
          [k, type, "#{k}:#{type}", i]
        else
          [k, 'text', k, i]
        end
      end
    end
    def parse_array(row)
      types.map do |k, type, _, i|
        convert type, row[i]
      end
    end
    def parse_hash(row)
      types.inject({}) do |memo, (k, type, orig_k, _)|
        v = row.fetch orig_k
        memo[k] = convert(type, v)
        memo
      end
    end
    private
    def convert(type, v)
      case type
      when 'text'
        # defaults to no parsing
        v
      when 'list'
        CSV.parse_line(v, col_sep: ';')
      when 'date'
        Time.parse(v).to_date
      when 'time'
        Time.parse(v).to_date
      when 'number'
        v.to_f
      else
        v
      end
    end
  end
end
