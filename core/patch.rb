# coding: utf-8
# Copyright 2019 DragonRuby LLC
# MIT License
# tests.rb has been released under MIT (*only this file*).

# Contributors outside of DragonRuby who also hold Copyright:
# - Eli Raybon: https://github.com/eliraybon

module GTK
  class Tests
    attr_accessor :failed, :passed, :inconclusive

    def initialize
      @failed = []
      @passed = []
      @inconclusive = []
    end

    def run_test m
      $serialize_state_serialization_too_large = false
      GTK::Entity.__reset_id__!
      args = Args.new $gtk, nil
      assert = Assert.new
      begin
        log_test_running m
        send(m, args, assert)
        if !assert.assertion_performed
          log_inconclusive m
        else
          log_passed m
        end
      rescue Exception => e
        if test_signature_invalid_exception? e, m
          log_test_signature_incorrect m
        else
          mark_test_failed m, e
        end
      end
    end

    def test_methods_focused
      Object.methods.find_all { |m| m.start_with?( "focus_test_") }
    end

    def test_methods
      Object.methods.find_all { |m| m.start_with? "test_" }
    end

    # @gtk
    def start
      log "* TEST: gtk.test.start has been invoked."
      if test_methods_focused.length != 0
        @is_running = true
        test_methods_focused.each { |m| run_test m }
        print_summary
        @is_running = false
      elsif test_methods.length == 0
        log_no_tests_found
      else
        @is_running = true
        test_methods.each { |m| run_test m }
        print_summary
        @is_running = false
      end
    end

    def mark_test_failed m, e
      message = "Failed."
      self.failed << { m: m, e: e }
      log message
    end

    def running?
      @is_running
    end

    def log_inconclusive m
      self.inconclusive << {m: m}
      log "Inconclusive."
    end

    def log_passed m
      self.passed << {m: m}
      # TODO if format doted
      # log "Passed."
    end

    def log_no_tests_found
      log <<-S
No tests were found. To create a test. Define a method
that begins with test_. For example:
#+begin_src
def test_game_over args, assert

end
#+end_src
S
    end

    def log_test_running m
      # log "** Running: #{m}"
      # TODO if format doted
      print ".".green
    end

    def test_signature_invalid_exception? e, m
      error_message = "'#{m.to_s}': wrong number of arguments"
      e.to_s.start_with?(error_message)
    end

    def log_test_signature_incorrect m
      log "TEST METHOD INVALID:", <<-S
I found a test method called :#{m}. But it needs to have
the following method signature:
#+begin_src
def #{m} args, assert

end
#+end_src
Please update the method signature to match the code above. If you
did not intend this to be a test method. Rename the method so it does
not start with "test_".
S
    end

    def clear_summary
      @passed.clear
      @inconclusive.clear
      @failed.clear
    end

    def print_summary
      log "** Summary"
      #log "*** Passed"
      log " #{self.passed.length} ✅ test(s) passed       ".green.reverse_color
      #self.passed.each { |h| log "**** :#{h[:m]}" }
      self.passed.each_with_index { |h,index| log " #{' ' if index < 9} #{index + 1} ✅ #{h[:m].to_s.split('_').drop(1).join('_') }".green }
      #log "*** Inconclusive"
      if self.inconclusive.length > 0
        log_once :assertion_ok_note, <<-S
NOTE FOR INCONCLUSIVE TESTS: No assertion was performed in the test.
Add assert.ok! at the end of the test if you are using your own assertions.
S
      end
      log " #{self.inconclusive.length} 🔀 test(s) inconclusive ".brown.reverse_color
      self.inconclusive.each { |h| log "**** :#{h[:m]}" }
      #log "*** Failed"
      if self.failed.length > 0
        log " #{self.failed.length} ❌ test(s) failed       ".red.reverse_color
      else
        log " #{self.failed.length} ➖ test(s) failed       ".reverse_color
      end
      self.failed.each_with_index do |h, index|
        #log "**** Test name: :#{h[:m]}".red
        puts "#{index + 1} ❌ #{h[:m]}".red
        log "#{h[:e].to_s.gsub("* ERROR:", "").strip}".red
        a = "#{h[:e].__backtrace_to_org__}"
        a = a.split("\n")#.insert(-2, "-").push("-")
        a[-1] = a[-1].reverse_color
        a = a.reverse
        last = a.pop
        a.unshift last
        # TODO pouvoir prendre just le dernier fichier ou la trace
        log a.take(2).join("\n")
      end
    end
  end
end
