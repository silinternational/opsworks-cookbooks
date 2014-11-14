# Helper methods for PHP related recipes
module Silphp
  module Helper
    def self.hash_to_array(hash, lines = '')
      hash.each do |name, value|
        lines << case value
                 when Hash
                   "\"#{name}\" => array(\n\t#{hash_to_array(value)}),\n"
                 when Array
                   "\"#{name}\" => array(\"#{value.join('","')}\"),\n"
                 when nil
                   "\"#{name}\" => null,\n"
                 when Integer
                   "\"#{name}\" => #{value},\n"
                 when TrueClass
                   "\"#{name}\" => #{value},\n"
                 when FalseClass
                   "\"#{name}\" => #{value},\n"
                 else
                   "\"#{name}\" => \"#{value}\",\n"
                 end
      end
      return lines
    end
  end
end
Chef::Recipe.send(:include, Silphp::Helper)