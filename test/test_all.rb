require "#{File.dirname(__FILE__)}/../lib/santa"
require 'test/unit'

class TestSanta < Test::Unit::TestCase

  def setup
    @santa = Santa.new
  end

  def test_command
    @santa.deb 'xyz'
    assert_equal [["apt-get", "update"], ["apt-get", "install", "-y", "xyz"]], @santa.commands_to_run 
  end

  def test_add_repo
    @santa.instance_eval do 
      repo 'rrr' do
        deb 'xyz'
      end
    end
    assert_equal [["add-apt-repository", "-y", "rrr"],["apt-get", "update"], ["apt-get", "install", "-y", "xyz"]], @santa.commands_to_run 
  end

  def test_add_repo
    @santa.instance_eval do 
      deb 'xyz', repo: 'rrr'
    end
    assert_equal [["add-apt-repository", "-y", "rrr"],["apt-get", "update"], ["apt-get", "install", "-y", "xyz"]], @santa.commands_to_run 
  end



end

