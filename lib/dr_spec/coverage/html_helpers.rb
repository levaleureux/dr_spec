module DrSpec
  module Coverage
    module HtmlHelpers
      def color_for_pct(value)
        return "#e74c3c" if value < 50
        return "#f39c12" if value < 80

        "#27ae60"
      end

      def pct(covered, total)
        return 0.0 if total == 0

        (covered.to_f / total * 100).round(1)
      end

      def escape_html(str)
        str.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
      end

      def source_line(line, num, hits)
        safe_line = escape_html(line.chomp)
        hit_count = hits[num]
        css_class = line_class(hit_count)
        count_label = hit_count ? "#{hit_count}x" : ""

        "<span class=\"line #{css_class}\">" \
          "<span class=\"ln\">#{num.to_s.rjust(4)}</span>" \
          "<span class=\"hits\">#{count_label.rjust(4)}</span> " \
          "#{safe_line}" \
          "</span>"
      end

      def line_class(hit_count)
        return "no-exec" if hit_count.nil?
        return "uncovered" if hit_count == 0

        "covered"
      end
    end
  end
end
