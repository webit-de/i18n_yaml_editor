# frozen_string_literal: true
require 'tempfile'

# captures $stdout
# @example
#   out = capture_out do
#     puts '1'  # captured
#     warn '2'  # printed
#     puts '3'  # captured
#     warn '4'  # printed
#   end
#   out # => "1\n3\n"
def capture_out
  captured_stdout = Tempfile.new('out')

  orig_stdout = $stdout.dup
  $stdout.reopen captured_stdout

  yield

  $stdout.rewind

  captured_stdout.read
ensure
  captured_stdout.unlink
  $stdout.reopen orig_stdout
end

# captures $stderr
# @example
#   err = capture_err do
#     puts '1'  # printed
#     warn '2'  # captured
#     puts '3'  # printed
#     warn '4'  # captured
#   end
#   err #=> "2\n4\n"
def capture_err
  captured_stderr = Tempfile.new('err')

  orig_stderr = $stderr.dup
  $stderr.reopen captured_stderr

  yield

  $stderr.rewind

  captured_stderr.read
ensure
  captured_stderr.unlink
  $stderr.reopen orig_stderr
end

# captures $stdout and $stderr
# @example
#   out, err = capture_io do
#     puts '1'  # captured
#     warn '2'  # captured
#     puts '3'  # captured
#     warn '4'  # captured
#   end
#   out # => "1\n3\n"
#   err #=> "2\n4\n"
def capture_io
  err = nil
  out = capture_out do
    err = capture_err do
      yield
    end
  end

  [out, err]
end
