$LOAD_PATH.unshift(File.dirname(__FILE__))

require "pathname"
class AssertionError < RuntimeError
end

def assert (m)
  if yield == false
      puts m
      raise AssertionError
  end
end


def PathJoin(dir,name)
  if dir.end_with?("/")
    return dir + name
  else
    return dir + "/" + name
  end
end

def ClearPath(p)
  Dir.foreach(p) { |f|
    if f.end_with?(".")
      next
    end
    path = PathJoin(p,f)
    if File.exist?(path)
        File.delete(path)
    end
  }
end

def WriteDataToFile(text, path)
  if File.exist?(path)
    File.delete(path)
  end
  file = File.new(path, "w")
  file.puts text
  file.close

end





def FindPathHasFile(currentpath, name)
  cp = Pathname.new(currentpath)
  realpath = cp.realpath
  if realpath.to_path== '/'
    return nil
  end

  path = nil
  Dir.foreach(realpath) do |e|
    if e.end_with?(name)
      path = PathJoin(realpath.to_path,e)
    end
  end
  if path == nil
    p = Pathname.new(currentpath)
    return FindPathHasFile(p.realpath.parent, name)
  else
    return path
  end
end

