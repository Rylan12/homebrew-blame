# frozen_string_literal: true

module Homebrew
  module_function

  def blame_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `blame`

        Show `git blame` output on <formula>.
      EOS
    end
  end

  def blame
    ohai "Hello!"
  end
end
