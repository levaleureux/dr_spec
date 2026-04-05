module DrSpec
  module Coverage
    module HtmlStyle
      def self.css
        <<~CSS
          * { margin: 0; padding: 0; box-sizing: border-box; }
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #1a1a2e; color: #eee; padding: 2rem; max-width: 1100px; margin: 0 auto;
          }
          header { margin-bottom: 2rem; }
          h1 { font-size: 1.8rem; margin-bottom: 0.5rem; color: #fff; }
          h2 { font-size: 1.3rem; margin: 1.5rem 0 0.8rem; color: #ccc; }
          h3 { font-size: 1rem; margin-bottom: 0.5rem; color: #ddd; }
          .total { display: flex; align-items: center; gap: 1rem; }
          .badge {
            display: inline-block; padding: 0.4rem 1rem; border-radius: 6px;
            font-size: 1.4rem; font-weight: bold; color: #fff;
          }
          .badge-sm {
            display: inline-block; padding: 0.2rem 0.6rem; border-radius: 4px;
            font-size: 0.8rem; font-weight: bold; color: #fff; margin-left: 0.5rem;
          }
          .stats { font-size: 1rem; color: #aaa; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 2rem; }
          th {
            text-align: left; padding: 0.6rem; border-bottom: 2px solid #333;
            color: #888; font-size: 0.85rem;
          }
          td { padding: 0.5rem 0.6rem; border-bottom: 1px solid #2a2a3e; }
          td a { color: #7ec8e3; text-decoration: none; }
          td a:hover { text-decoration: underline; }
          .bar-bg {
            display: inline-block; width: 120px; height: 8px; background: #333;
            border-radius: 4px; vertical-align: middle; margin-right: 0.5rem;
          }
          .bar { height: 100%; border-radius: 4px; transition: width 0.3s; }
          .pct { font-weight: bold; font-size: 0.9rem; }
          .file-detail { margin: 2rem 0; }
          pre.source {
            background: #16213e; border-radius: 8px; padding: 1rem;
            overflow-x: auto; font-size: 0.82rem; line-height: 1.5;
          }
          .line { display: block; padding: 0 0.5rem; }
          .line.covered { background: rgba(39, 174, 96, 0.15); }
          .line.uncovered { background: rgba(231, 76, 60, 0.2); }
          .line.no-exec { }
          .ln { color: #555; user-select: none; }
          .hits { color: #888; user-select: none; font-size: 0.75rem; }
          .uncovered .hits { color: #e74c3c; }
          .covered .hits { color: #27ae60; }
          footer {
            margin-top: 3rem; padding-top: 1rem; border-top: 1px solid #333;
            color: #555; font-size: 0.8rem;
          }
        CSS
      end
    end
  end
end
