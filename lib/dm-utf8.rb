require 'iconv'
require 'rubygems'
begin 
  require 'oniguruma'
rescue Exception
end
require "dm-core"

module DmUtf8

  class Filter
    # http://po-ru.com/diary/fixing-invalid-utf-8-in-ruby-revisited/
    def self.filter(untrusted_string)
      return untrusted_string unless untrusted_string.class == String
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      trusted_string = ic.iconv(untrusted_string + ' ')[0..-2]
      
      # http://www.igvita.com/2007/04/11/secure-utf-8-input-in-rails/
      
      
      if Object.constants.member? "Oniguruma"
        # Finally filter out all Cx category graphemes
        reg = Oniguruma::ORegexp.new("\\p{C}", {:encoding => Oniguruma::ENCODING_UTF8})
        
        # Erase the Cx graphemes from our validated string
        reg.gsub(trusted_string, '')
      else
        trusted_string 
      end
    end
  end
end

module DataMapper
  module Utf8
    def self.included(model)
      if model.method_defined?(:attribute_set) && !model.method_defined?(:attribute_set_raw)
        model.send(:alias_method, :attribute_set_raw, :attribute_set)
        model.send(:alias_method, :attribute_set,  :attribute_set_valid)
      end
    end
      
    def attribute_set_valid(name, value)
      attribute_set_raw(name, DmUtf8::Filter.filter(value))
    end
  end

  Resource::append_inclusions Utf8
end
