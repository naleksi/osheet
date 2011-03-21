require "test/helper"
require 'osheet/cell'

class Osheet::CellTest < Test::Unit::TestCase

  context "Osheet::Cell" do
    subject { Osheet::Cell.new }

    should_have_instance_methods :data, :format, :colspan, :rowspan, :href
    should_have_instance_methods :style_class

    should "set it's defaults" do
      assert_equal '', subject.send(:instance_variable_get, "@style_class")
      assert_equal nil, subject.send(:instance_variable_get, "@data")
      assert_equal nil, subject.send(:instance_variable_get, "@format")
      assert_equal 1,   subject.send(:instance_variable_get, "@colspan")
      assert_equal 1,   subject.send(:instance_variable_get, "@rowspan")
      assert_equal nil,   subject.send(:instance_variable_get, "@href")
    end

    context "that has attributes" do
      subject do
        Osheet::Cell.new do
          style_class "awesome thing"
          data    "Poo"
          format  '@'
          colspan 4
          rowspan 2
          href "http://www.google.com"
        end
      end

      should "should set them correctly" do
        assert_equal "awesome thing", subject.send(:instance_variable_get, "@style_class")
        assert_equal "Poo", subject.send(:instance_variable_get, "@data")
        assert_equal '@', subject.send(:instance_variable_get, "@format")
        assert_equal 4,     subject.send(:instance_variable_get, "@colspan")
        assert_equal 2,     subject.send(:instance_variable_get, "@rowspan")
        assert_equal "http://www.google.com", subject.send(:instance_variable_get, "@href")
      end
    end

    should "type cast data strings/symbols" do
      cell = Osheet::Cell.new{data "a string"}
      assert_kind_of ::String, cell.send(:instance_variable_get, "@data")
      cell = Osheet::Cell.new{data :awesome}
      assert_kind_of ::String, cell.send(:instance_variable_get, "@data")
    end
    should "type cast data dates" do
      cell = Osheet::Cell.new{data Date.today}
      assert_kind_of ::Date, cell.send(:instance_variable_get, "@data")
    end
    should "type cast data numerics" do
      cell = Osheet::Cell.new{data 1}
      assert_kind_of ::Numeric, cell.send(:instance_variable_get, "@data")
      cell = Osheet::Cell.new{data 1.0}
      assert_kind_of ::Numeric, cell.send(:instance_variable_get, "@data")
    end
    should "type cast all other data to string" do
      cell = Osheet::Cell.new{data Osheet}
      assert_kind_of String, cell.send(:instance_variable_get, "@data")
      cell = Osheet::Cell.new{data([:a, 'Aye'])}
      assert_kind_of String, cell.send(:instance_variable_get, "@data")
      cell = Osheet::Cell.new{data({:a => 'Aye'})}
      assert_kind_of String, cell.send(:instance_variable_get, "@data")
    end


  end

end