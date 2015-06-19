$LOAD_PATH.unshift(File.dirname(__FILE__))
require "FileUtils"
def OC_Class_HeaderWithProperties(name, properties)
  out = "@interface " + name + "\n"
  properties.each { |x|
    out = out + x + "\n"
  }
  out = out + "@end"
  outputt
end

def OCClassHeaderWithModel(m)
  ocheader= '''
#import <Mantle.h>
<import_class>
@interface <class_name> : MTLModel <MTLJSONSerializing>
<properties>
@end
  '''

  p = ""
  m.records.each { |r|
    p = p + r.codeOutput
  }

  ocheader = ocheader.gsub(/<properties>/, p)
  ocheader = ocheader.gsub(/<class_name>/, m.name)

  importclass = ""
  m.records.each{ |r|
    if  r.respond_to?("importHeader")
      importclass = importclass + r.importHeader + "\n"
    end
  }

  ocheader = ocheader.gsub(/<import_class>/, importclass)

  ocheader
end

def OCClassImplitationWithModel(m)

  ocim = '''
#import "<header_name>.h"
@implementation <class_name>
+ (NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{<keyvalues>
            };
}
<json_functions>
@end
'''

  keys = "";
  m.records.each{ |r|
    keys = keys + "@\"#{r.name}\":@\"#{r.name}\",\n"
  }

  ocim = ocim.gsub(/<class_name>/, m.name)
  ocim = ocim.gsub(/<keyvalues>/,keys)
  ocim = ocim.gsub(/<header_name>/, m.name)

  funcs = ""
  m.records.each{ |r|
    if r.respond_to?("jsonTransformer")
      funcs = funcs + r.jsonTransformer +  "\n"
    end
  }

  ocim = ocim.gsub(/<json_functions>/, funcs)

  ocim
end

def OutPutFiles(dir)
  FileUtils.mkdir_p(dir) unless File.exist?(dir)
  $JSONModelCache.each_value{|m|
    header = OCClassHeaderWithModel(m)
    implitation = OCClassImplitationWithModel(m)
    headerpath = PathJoin(dir, m.name + ".h")
    impath = PathJoin(dir, m.name + ".m")
    WriteDataToFile(header, headerpath)
    WriteDataToFile(implitation, impath)
  }
end
