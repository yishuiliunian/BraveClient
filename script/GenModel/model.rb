$LOAD_PATH.unshift(File.dirname(__FILE__))

class OutputFile
  attr_accessor :name
  attr_accessor :content

  def initialize(name, content)
    @name = name
    @content = content
  end
end


class JSONRecord
  attr_accessor :name
  attr_accessor :type
  def initialize(type, name)
    @name = name
    @type = type
  end

  def codeOutput
    nil
  end
end


class JSONModel
  attr_accessor :records
  attr_accessor :name
  def initialize
    @records = []
  end

  def addRecord(record)
    assert('record == nil') {record != nil}
    assert('record is not class of JSONRecord'){record.is_a?(JSONRecord)}
    @records << record
  end
end

$JSONModelCache = {}

def GetJSONModel(key)
  model = $JSONModelCache[key]
  model = JSONModel.new() unless model != nil
  model.name = key
  $JSONModelCache[key] = model
  model
end

def model(modelName)
  model = GetJSONModel(modelName)
  yield model
end



def OutputModel(model)
    header = ''
end


#oc代码生成

def OC_Property2(p1, p2, type, name)
  "@property(" + p1 + "," + p2 + ")" + " " + type + " " + name + ";\n"
end

def OC_Property_Object(type, name)
  type = type+"*"
  OC_Property2("nonatomic", "strong", type , name)
end

def OC_Property_Number(type, name)
  OC_Property2("nonatomic", "assign", type, name)
end


def RequestAddNumberParaters(value, name)
   "[self addParamterNumber:@(#{value}) forKey:@\"#{name}\"];"
end

def RequestAddObjectParamters(value, name)
  "[self addParamter:#{value} forKey:@\"#{name}\"];"
end

class OCObjectRecord < JSONRecord
  def codeOutput
      OC_Property_Object(@type, @name)
  end

  def paramterOutput
    RequestAddObjectParamters("self.#{@name}", @name)
  end
end

class OCCustomObjectRecord < OCObjectRecord
  def jsonTransformer
"
+ (NSValueTransformer*) #{@name}JSONTransformer
{
   return [NSValueTransformer mtl_validatingTransformerForClass:NSClassFromString(@\"#{@type}\")];
}
"
  end
end

class OCArrayRecord < OCObjectRecord
  attr_accessor :ocClass
  def initialize(type = $JSONTypeArray, name, ocClass)
    super(type, name)
    @ocClass = ocClass

  end

  def jsonTransformer
    if @ocClass == "NSString"
      return ""
    else
      return  " \n
    + (NSValueTransformer*) #{@name}JSONTransformer  {
      return [NSValueTransformer mtl_arrayMappingTransformerWithTransformer:
                                  [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:NSClassFromString(@\"#@ocClass\")]];
    }
    "
    end
  end

  def importHeader
    if @ocClass == "NSString"
        return ""
    end
    "#import \"#{@ocClass}.h\" \n"
  end
end

class OCStringRecord <OCObjectRecord
  def jsonTransformer
    '''
+ (NSValueTransformer*) <name>JSONTransformer
{
    return [NSValueTransformer valueTransformerForName:TMDStringValueTransformerName];
}
    '''.gsub(/<name>/,@name)
  end

  def importHeader
"#import \"NSValueTransformer+NSString.h\"\n"
  end
end
class OCPointRecord < OCObjectRecord
  def importHeader
     "#import \"PMLinePoint.h\""
  end
  def jsonTransformer
'''
+ (NSValueTransformer*) <name>JSONTransformer
{
 return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString* str = value;
            NSArray* values = [str componentsSeparatedByString:@","];
            if (values.count == 2) {
                PMLinePoint* point = [PMLinePoint new];
                point.lat = [values[0] floatValue];
                point.lng = [values[0] floatValue];
                *success = YES;
                return point;
            }
        }
        
        PMLinePoint* point = [PMLinePoint new];
        point.lat = 0;
        point.lng = 0;
        *success = YES;
        return point;
        
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[PMLinePoint class]]) {
            PMLinePoint* point = (PMLinePoint*) value;
            *success = YES;
            return [NSString stringWithFormat:@"%f,%f", point.lat, point.lng];
        }
        return nil;
    }];

}
'''.gsub(/<name>/,@name)
  end
end

class OCNumberRecord < JSONRecord
  def codeOutput
    OC_Property_Number(@type, @name)
  end

  def paramterOutput
    RequestAddNumberParaters("self.#{@name}", @name)
  end
end

def array(name, ocClass ,model=nil)
  r = OCArrayRecord.new("NSArray",name, ocClass)
  model.addRecord(r)
end

def object(name, ocClass, model = nil)
  r = OCCustomObjectRecord.new(ocClass, name, model)
  model.addRecord(r)
end
def number(type, name, model = nil)
  r= OCNumberRecord.new(type, name)
  model.addRecord(r)
end

def point(name, model)
  r = OCPointRecord.new("PMLinePoint",name)
  model.addRecord(r)
end

def int32(name, model)
  number("int32_t", name , model)
end

def int64(name, model)
  number "int64_t", name, model
end

def float(name, model)
  number "float" ,name ,model
end


def double(name, model)
  number "double", name, model
end

def bool(name, model)
  number "BOOL", name, model
end

def string(name, model)
  r = OCStringRecord.new("NSString",name)
  model.addRecord(r)
end

