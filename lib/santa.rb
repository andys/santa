
class Santa
  attr_reader :commands_to_run

  def initialize(*str, &bl)
    @repos = []
    @commands_to_run = [['apt-get', 'update']]

    @lsb = {}
    File.read('/etc/lsb-release').lines.each {|line| @lsb.merge!(Hash[*line.chomp.split(/=/)]) }

    instance_eval(*str, &bl) if str.length > 0 || bl
  end

  def deb(debname, opts={})
    if(r = opts.delete(:repo))
      repo(*r)
    end
    append_cmd 'apt-get', 'install', '-y', debname.to_s
  end

  def cmd(*cmds)
    cmds.unshift 'sudo' unless ENV['USER'] == 'root'
    puts "--> #{cmds.join(' ')}"
    raise "command failed: exit status #{$?}" unless system(*cmds)
  end

  def executable?(cmd)
    ENV['PATH'].split(':').any? {|f| File.executable?("#{f}/#{cmd}")}
  end
  
  def go!
    @commands_to_run.each {|c| cmd(*c) }
  end
  
  def prepend_cmd(*cmds)
    @commands_to_run.unshift cmds unless @commands_to_run.include? cmds
  end

  def append_cmd(*cmds)
    @commands_to_run.push cmds unless @commands_to_run.include? cmds
  end
  
  def repo(*repos, &bl)
    repos.each {|r| prepend_cmd 'add-apt-repository', '-y', r.to_s }
    prepend_cmd 'apt-get', 'install', '-y', 'python-software-properties' unless executable? 'add-apt-repository'

    instance_eval &bl if bl
  end
end
