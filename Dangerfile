github.dismiss_out_of_range_messages

warn("Big PR") if git.lines_of_code > 500
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

swiftlint.binary_path = '/usr/local/bin/swiftlint'
swiftlint.lint_files inline_mode: true, fail_on_error: true