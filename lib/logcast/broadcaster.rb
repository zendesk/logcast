require 'logger'

class Logcast::Broadcaster
  def initialize(*logs)
    logs.each {|log| broadcast(log)}
  end

  def broadcast(log)
    logs << log unless logs.include?(log)
  end

  def logs
    Thread.main[:logs] ||= []
  end

  # Rails 2
  def write(*args)
    logs.each do |log|
      if log.respond_to?(:write)
        log.write(*args)
      else
        log << *args
      end
    end
  end

  # Rails 3
  def add(*args)
    logs.each do |log|
      if log.respond_to?(:add)
        log.add(*args)
      else
        log.write(args[1])
      end
    end
  end

  def level=(x)
    logs.each do |log|
      t.level = x if t.respond_to?(:level=)
    end
  end

  def level
    logs.detect {|log| log.respond_to?(:level)}.try(:level)
  end

  def flush
    logs.each(&:flush)
  end
end
