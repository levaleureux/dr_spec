module DrSpec
  module Coverage
    class Instrumenter
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
        depth = 0

        instrumented_lines = []

        lines.each_with_index do |line, index|
          line_num = index + 1
          stripped = line.strip

          # Handle =begin / =end block comments
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
            in_heredoc = false if stripped == heredoc_end
            instrumented_lines << line
            next
          end

          # Continuation line of an open multi-line literal (hash/array/call):
          # do not inject in the middle of the expression.
          if depth > 0
            instrumented_lines << line
            depth += bracket_delta(line)
            next
          end

          # Detect heredoc start
          if stripped.include?("<<")
            heredoc_marker = detect_heredoc(stripped)
            if heredoc_marker
              in_heredoc = true
              heredoc_end = heredoc_marker
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
          depth += bracket_delta(line)
        end

        instrumented_lines.join("\n")
      end

      private

      # Variation nette de profondeur de parenthésage pour une ligne :
      # +1 par { [ ( et -1 par } ] ), en ignorant le contenu des chaînes et
      # les commentaires (#). Pas de Regexp (indisponible en mRuby).
      def bracket_delta(line)
        delta = 0
        quote = nil
        i = 0
        while i < line.length
          c = line[i]
          if quote
            quote = nil if c == quote
          elsif c == "'" || c == '"'
            quote = c
          elsif c == "#"
            break
          elsif c == "{" || c == "[" || c == "("
            delta += 1
          elsif c == "}" || c == "]" || c == ")"
            delta -= 1
          end
          i += 1
        end
        delta
      end

      def skip_line?(stripped)
        return true if stripped == ""
        return true if stripped.start_with?("#")
        return true if SKIP_BARE.include?(stripped)
        return true if end_terminator?(stripped)

        SKIP_PREFIXES.any? { |prefix| stripped.start_with?(prefix) }
      end

      # Vrai pour un `end` terminateur de bloc, meme suivi d'un appel ou d'un
      # operateur (end, end.freeze, end), end,). Instrumenter ces lignes
      # placerait __dr_cov AVANT le end -> il deviendrait la derniere
      # expression du bloc et detournerait sa valeur de retour. On exclut les
      # identifiants commencant par "end" (ending, endpoint).
      def end_terminator?(stripped)
        return false unless stripped.start_with?("end")

        after = stripped[3]
        after.nil? || !word_char?(after)
      end

      def word_char?(char)
        (char >= "a" && char <= "z") ||
          (char >= "A" && char <= "Z") ||
          (char >= "0" && char <= "9") || char == "_"
      end

      def detect_heredoc(line)
        idx = 0
        while idx < line.length - 1
          if line[idx] == '<' && line[idx + 1] == '<'
            rest = line[(idx + 2)..-1]
            rest = rest[1..-1] if rest && (rest.start_with?("~") || rest.start_with?("-"))
            if rest && rest.length > 0
              if rest.start_with?("'") || rest.start_with?('"')
                end_quote = rest[0]
                end_idx = rest.index(end_quote, 1)
                return rest[1...end_idx] if end_idx
              else
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
  end
end
