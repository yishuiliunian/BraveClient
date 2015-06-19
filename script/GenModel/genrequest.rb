$LOAD_PATH.unshift(File.dirname(__FILE__))
require "request"
require "FileUtils"
def OutPutFileTo(rootPath, subpath, project, files, over)
  p = Pathname.new(rootPath).join(subpath).to_path
  FileUtils.mkdir_p(p) unless  File.exist?(p) == true
  if over == true
    ClearPath(p)
  end
  target = project.targets.first
  group = project.main_group.find_subpath(subpath, true)
  group.clear

  files.each {|f|
    path = PathJoin(p, f.name)
    if File.exist?(path) && over == false
      next
    end

    WriteDataToFile(f.content, path)
  }

  fileRefs = []
  print p
  print "\n"
  Dir.foreach(p) do |file|
    if file.end_with?(".")
      next
    end
    fpath = PathJoin(p, file)
    ref = group.new_reference(fpath)
    fileRefs << ref
  end
  target.add_file_references(fileRefs)
end
