module AnlekBootstrapHelper::RspecMatchers
  class Matcher
    def wrap(actual)
      if actual.respond_to?("has_selector?")
        actual
      else
        Capybara.string(actual.to_s)
      end
    end
  end
  class HaveIcon < Matcher
    def initialize(item, options={})
      @expected = item
      options.symbolize_keys!
      @prefix = options[:prefix] || AnlekBootstrapHelper::IconHelper::ICON_PREFIX
    end

    def description
      "has icon of #{@expected}"
    end

    def matches?(actual)
      @actual = actual
      wrap(@actual).assert_selector("i.#{@prefix}.#{@prefix}-#{@expected}")
      true
      rescue Capybara::ExpectationNotMet
        return false
    end

    def failure_message
      "expected that #{@actual} has icon #{@expected}"
    end

    def failure_message_when_negated
      "expected that #{@actual} doesn't has icon #{@expected}"
    end

    # RSpec 2 compatibility:
    alias_method :failure_message_for_should, :failure_message
    alias_method :failure_message_for_should_not, :failure_message_when_negated
  end

  def have_icon(*args)
    HaveIcon.new(*args)
  end
end

RSpec.configure do |config|
  config.include AnlekBootstrapHelper::RspecMatchers
end

