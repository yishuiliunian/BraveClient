$LOAD_PATH.unshift(File.dirname(__FILE__))
require "model"
require "utilities"
require "model"
class RequestOutPut
  attr_accessor :superHeader
  attr_accessor :superImplitaion
  attr_accessor :header
  attr_accessor :implitation
end

class Request
  attr_accessor :name
  attr_accessor :response
  attr_accessor :method
  attr_accessor :paramters

  def initialize(name)
    @name = name
    @paramters = []
  end


  def  headerTemplate
    '''
#import "MSRequest.h"
#import "<rsp_name>.h"
@interface <request_name> : MSRequest
<request_properties>
- (void) didGetMessage:(<rsp_name>*)message;
@end
    '''
  end

  def implitationTemplate
'''
#import "<request_name>.h"
#import <Mantle.h>
#import "<rsp_name>.h"
@implementation <request_name>

- (NSString*) method
{
    return @"<method_name>";
}
- (bool) loadParamters:(NSError *__autoreleasing *)error
{
    SendSuperFunctionWithError(loadParamters);
    <add_paramters>
    return YES;
}
- (void) onSuccess:(id)retobject
{
    NSError* error = nil;
    if ([retobject isKindOfClass:[NSArray class]]) {
        retobject = @{@"list":retobject};
    }
    if ([retobject isKindOfClass:[NSNull class]]) {
        [self didGetMessage:[<rsp_name> new]];
    } else {
        id list = retobject[@"list"];
        if ([list isKindOfClass:[NSString class]]) {
            if ([list isEqualToString:@""]) {
                NSMutableDictionary* dic = [retobject mutableCopy];
                dic[@"list"] = [NSNull null];
                retobject = dic;
            }
        }
        <rsp_name>* message = [MTLJSONAdapter modelOfClass:NSClassFromString(@"<rsp_name>") fromJSONDictionary:retobject error:&error];
        if (error) {
            [self onError:error];
            return;
        }
        [self didGetMessage:message];
    }
}

- (void) didGetMessage:(<rsp_name>*)message
{
   [self doUIOnSuccced:message];
}
@end
'''
  end

  def propertiesOutPut
    out = "\n"
    @paramters.each { |r|
        out = out + r.codeOutput + "\n"
    }
    out
  end

  def paramtersOutput
    out = "\n"
    @paramters.each { |r|
      out = out + r.paramterOutput + "\n"
    }
    out
  end

  def addParamter(p)
    assert("is not class of Record") {p.is_a?(JSONRecord)}
    @paramters << p
  end

  def output


    ct = "#import \"<super_name>.h\"
@interface <class_name> : <super_name>
@end"

    cmt = '''
#import "<class_name>.h"

@implementation <class_name>
- (void) didGetMessage:(<rsp_name>*)message
{

}
@end

'''
    t = self.headerTemplate

    supername = "__"+@name
    t = t.gsub(/<request_name>/, supername)
    t = t.gsub(/<request_properties>/, self.propertiesOutPut)
    t = t.gsub(/<rsp_name>/, @response)

    imt = self.implitationTemplate
    imt = imt.gsub(/<rsp_name>/,@response)
    imt = imt.gsub(/<request_name>/,supername)
    imt = imt.gsub(/<method_name>/, @method)
    imt = imt.gsub(/<add_paramters>/, self.paramtersOutput)




    ct = ct.gsub(/<super_name>/, supername)
    ct = ct.gsub(/<class_name>/, @name)

    cmt = cmt.gsub(/<class_name>/, @name)
    cmt = cmt.gsub(/<rsp_name>/,@response)

    reqOutput = RequestOutPut.new()
    reqOutput.superHeader = OutputFile.new("#{supername}.h", t)
    reqOutput.superImplitaion = OutputFile.new("#{supername}.m", imt)
    reqOutput.header = OutputFile.new("#{@name}.h",ct)
    reqOutput.implitation = OutputFile.new("#{@name}.m",cmt)

    reqOutput

  end

end


$JSONReqeustCache = {}

def getJSONRequest(key)
  r = $JSONReqeustCache[key]
  r = Request.new(key) unless r!= nil
  $JSONReqeustCache[key] = r
  r
end




def paramter_with_record(p , req)
  req.addParamter(p)
end

def p_number(type, name, req)
  r = OCNumberRecord.new(type , name)
  paramter_with_record(r, req)
end



def p_int32(name, req)
  p_number("int32_t", name, req)
end

def p_int64(name, req)
  p_number("int64_t", name, req)
end

def p_string(name, req)
  r = OCObjectRecord.new("NSString",name)
  req.addParamter(r)
end

def method(m , req)
  req.method = m
end

def response(rsp , req)
  req.response = rsp
end

def requestModel(name)
  r = getJSONRequest(name)
  yield r
end

