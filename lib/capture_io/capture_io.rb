# frozen_string_literal: true

require 'tempfile'

# captures arbitrary io
def capture(io)
  captured_io = Tempfile.new

  orig_stdout = io.dup
  io.reopen captured_io

  yield

  io.rewind

  captured_io.read
ensure
  captured_io.unlink
  io.reopen orig_stdout
end

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
  capture($stdout) do
    yield
  end
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
  capture($stderr) do
    yield
  end
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
