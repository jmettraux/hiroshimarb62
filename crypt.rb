
require 'ffi'

module Fubar
  extend FFI::Library

  # man 3 crypt
  #
  # char *crypt(const char *key, const char *salt);

  #ffi_lib '/usr/lib/libc.dylib'
  ffi_lib 'c'

  attach_function :crypt, [ :string, :string ], :string
end


if $0 == __FILE__

  string, salt = ARGV

  if [ nil, '-h', '--help' ].include?(string)
    puts "ruby #{$0} string [salt]"
    puts "  --> prints the result of crypt(string, salt || 'NaCl')"
  else
    puts Fubar.crypt(string, salt || 'NaCl')
  end
end

