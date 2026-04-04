# POC: Minimal source instrumenter
#
# Reads Ruby source and injects __dr_cov() calls at each executable line.
# No Regexp used — mruby compatible.
#

class PocInstrumenter
  SKIP_BARE = [
    "end", "else", "begin", "do", "{", "}", "rescue", "ensure", "then"
  ].freeze

  SKIP_PREFIXES = [
    "module ", "class ", "require ", "require_relative ",
    "def ", "rescue ", "ensure ", "when ", "elsif "
  ].freeze

  def instrument(source, file_path, tracker)
    lines = source.split("\n")
    source_lines = lines.map { |l| "#{l}\n" }
    tracker.register(file_path, source_lines)

    in_heredoc = false
    heredoc_end = nil
    in_block_comment = false

    instrumented_lines = []

    lines.each_with_index do |line, index|
      line_num = index + 1

      # Handle =begin / =end block comments
      stripped = line.strip
      if stripped == "=begin"
        in_block_comment = true
        instrumented_lines << line
        next
      end
      if stripped == "=end"
        in_block_comment = false
        instrumented_lines << line
        next
      end
      if in_block_comment
        instrumented_lines << line
        next
      end

      # Handle heredocs
      if in_heredoc
        if stripped == heredoc_end
          in_heredoc = false
        end
        instrumented_lines << line
        next
      end

      # Detect heredoc start (<<WORD or <<~WORD or <<-WORD)
      if stripped.include?("<<")
        heredoc_marker = detect_heredoc(stripped)
        if heredoc_marker
          in_heredoc = true
          heredoc_end = heredoc_marker
          # The line with << is executable
          tracker.mark_executable(file_path, line_num)
          instrumented_lines << "__dr_cov(\"#{file_path}\", #{line_num}); #{line}"
          next
        end
      end

      if skip_line?(stripped)
        instrumented_lines << line
      else
        tracker.mark_executable(file_path, line_num)
        instrumented_lines << "__dr_cov(\"#{file_path}\", #{line_num}); #{line}"
      end
    end

    instrumented_lines.join("\n")
  end

  private

  def skip_line?(stripped)
    # Empty line
    return true if stripped == ""

    # Comment
    return true if stripped.start_with?("#")

    # Bare structural keywords
    return true if SKIP_BARE.include?(stripped)

    # Lines starting with structural keywords
    SKIP_PREFIXES.any? { |prefix| stripped.start_with?(prefix) }
  end

  def detect_heredoc(line)
    # Look for << followed by a word (heredoc delimiter)
    # Handles <<WORD, <<~WORD, <<-WORD, <<'WORD', <<"WORD"
    idx = 0
    while idx < line.length - 1
      if line[idx] == '<' && line[idx + 1] == '<'
        rest = line[(idx + 2)..-1]
        # Skip ~ or -
        rest = rest[1..-1] if rest && (rest.start_with?("~") || rest.start_with?("-"))
        # Extract the delimiter word
        if rest && rest.length > 0
          # Remove quotes if present
          if rest.start_with?("'") || rest.start_with?('"')
            end_quote = rest[0]
            end_idx = rest.index(end_quote, 1)
            if end_idx
              return rest[1...end_idx]
            end
          else
            # Read word characters
            word = ""
            rest.each_char do |c|
              if (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_'
                word << c
              else
                break
              end
            end
            return word if word.length > 0
          end
        end
      end
      idx += 1
    end
    nil
  end
end
