require 'bundler/setup'
require 'test/unit'
require 'mocha/test_unit'

$LOAD_PATH.unshift File.expand_path('..', __FILE__)
require 'notifier'

class Notifier < BaseNotifier
  # a dummy event
  def some_event
    true
  end
end

class NotifierTest < Test::Unit::TestCase
  def setup
    # allow all events to be delivered
    Notifier.stubs(:notify?).returns(true)
  end

  def test_delegates_to_method_with_same_name
    Notifier.expects(:some_event).returns(true)
    assert Notifier.notify :some_event
  end

  def test_returns_whatever_the_event_returns
    Notifier.expects(:some_event).returns('some_value')
    assert_equal 'some_value', Notifier.notify(:some_event)
  end

  def test_passes_no_parameter_on
    Notifier.expects(:some_event).with(nil).returns(true)
    assert Notifier.notify(:some_event)
  end

  def test_passes_on_a_single_paramter
    Notifier.expects(:some_event).with('some_value').returns(true)
    assert Notifier.notify :some_event, 'some_value'
  end

  def test_passes_on_a_single_parameter_that_is_a_hash
    Notifier.expects(:some_event).with({'key' => 'value'}).returns(true)
    assert Notifier.notify :some_event, {'key' => 'value'}
  end

  def test_passes_on_multiple_parameters
    Notifier.expects(:some_event).with('some_value', 'some_other_value').returns(true)
    assert Notifier.notify :some_event, 'some_value', 'some_other_value'
  end

  def test_returns_false_if_delegate_method_does_not_exist_rather_than_raising_an_exception
    assert_nothing_raised NoMethodError do
      assert !Notifier.notify(:some_not_implemented_event)
    end
  end
end

class NotifierUnstubbedTest < Test::Unit::TestCase
  def test_delegates_to_method_when_allowed
    Notifier.stubs(:notify?).returns(true)
    Notifier.expects(:some_event).returns(true)
    assert Notifier.notify :some_event
  end

  def test_will_not_delegate_when_not_allowed
    Notifier.expects(:notify?).returns(false)
    Notifier.expects(:some_event).never
    assert !Notifier.notify(:some_event)
  end

  # def test_notify_query_delegates_to_events_collection
  #   Notifier.stubs(:notified_events).returns(['some_event'])
  #   Notifier.public_class_method :notify?
  #
  #   assert  Notifier.notify?('some_event')
  #   assert !Notifier.notify?('some_event_not_allowed')
  #
  #   # works also with symbols
  #   assert  Notifier.notify?(:some_event)
  #   assert !Notifier.notify?(:some_event_not_allowed)
  # end
end
