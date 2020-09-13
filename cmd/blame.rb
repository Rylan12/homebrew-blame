# frozen_string_literal: true

module Homebrew
  module_function

  def blame_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `blame` <formula> [<revision>] [-L <line> | -L <start>,<end>]

        Show `git blame` output on <formula>.
      EOS
      flag "-L", "--lines=",
           description: "Annotate only the given line range. "\
                        "`-L <line>` will annotate only the given line number. "\
                        "`-L <start>``,<end>` will annotate from <start> to <end>. "\
                        "Leave either <start> or <end> blank (keeping the comma) "\
                        "to annotate from the first line to <end> or from <start> "\
                        "to the last line respectively."
      min_named 1
      max_named 2
    end
  end

  def blame
    args = blame_args.parse

    # As this command is simplifying user-run commands then let's just use a
    # user path, too.
    ENV["PATH"] = ENV["HOMEBREW_PATH"]

    formula, revision = args.named
    path = Formulary.path formula
    tap = Tap.from_path path

    odie "No available formula with the name \"#{formula}\"" unless File.exist? path

    lines = args.lines
    lines = "#{lines},#{lines}" if lines.present? && !lines.include?(",")

    git_blame path.dirname, path, tap, revision, lines
  end

  def git_blame(cd_dir, path, tap, revision, lines)
    cd cd_dir
    repo = Utils.popen_read("git rev-parse --show-toplevel").chomp
    name = tap.to_s
    git_cd = "$(brew --repo #{tap})"

    if File.exist? "#{repo}/.git/shallow"
      opoo <<~EOS
        #{name} is a shallow clone so only partial output will be shown.
        To get a full clone run:
          git -C "#{git_cd}" fetch --unshallow
      EOS
    end

    git_args = []
    git_args << revision if revision.present?
    git_args << "-L" << lines if lines.present?
    git_args += ["--", path] if path.present?
    system "git", "blame", *git_args
  end
end
