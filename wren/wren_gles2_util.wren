import "wren_gles2" for GL, ClearFlag, BufferType, BufferHint, ShaderType, DataType, EnableCap, PrimitveType, ShaderParam, ProgramParam, TextureTarget, TextureParam, TextureWrapMode, TextureMagFilter, TextureMinFilter, TextureUnit, PixelType, PixelFormat, BlendFacSrc, BlendFacDst
import "buffer" for FloatArray, Uint16Array

class Gles2Util {
  static createTexture(w,h,opt){
    var texture = GL.createTexture()
    GL.bindTexture(TextureTarget.TEXTURE_2D, texture)
    GL.texImage2D(TextureTarget.TEXTURE_2D, 0, PixelFormat.RGBA, w, h, 0, PixelFormat.RGBA, PixelType.UNSIGNED_BYTE)
    GL.texParameteri(TextureTarget.TEXTURE_2D, TextureParam.TEXTURE_MAG_FILTER, opt["interpolate"] ? TextureMagFilter.LINEAR : TextureMagFilter.NEAREST)
    GL.texParameteri(TextureTarget.TEXTURE_2D, TextureParam.TEXTURE_MIN_FILTER, opt["interpolate"] ? TextureMagFilter.LINEAR : TextureMinFilter.NEAREST)
    return texture 
  }

  static createTexture(w,h){ Gles2Util.createTexture(w,h,{}) }

  static compileShader(vertCode, fragCode){
    var vertShader = GL.createShader(ShaderType.VERTEX_SHADER)
    GL.shaderSource(vertShader, vertCode)
    GL.compileShader(vertShader)
    var compiled = GL.getShaderParameter(vertShader, ShaderParam.COMPILE_STATUS)
    if(compiled == 0){
      Fiber.abort("Vertex shader compile error: \n"+ GL.getShaderInfoLog(vertShader))
    }
    var fragShader = GL.createShader(ShaderType.FRAGMENT_SHADER)
    GL.shaderSource(fragShader, fragCode)
    GL.compileShader(fragShader)
    compiled = GL.getShaderParameter(fragShader, ShaderParam.COMPILE_STATUS)
    if(compiled == 0){
      Fiber.abort("Fragment shader compile error: \n"+ GL.getShaderInfoLog(fragShader))
    }
    var shaderProgram = GL.createProgram()
    GL.attachShader(shaderProgram, vertShader)
    GL.attachShader(shaderProgram, fragShader)
    GL.linkProgram(shaderProgram)
    compiled = GL.getProgramParameter(shaderProgram, ProgramParam.LINK_STATUS)
    if(compiled == 0){
      Fiber.abort("Shader link error: "+ GL.getProgramInfoLog(shaderProgram))
    }
    GL.deleteShader(vertShader)
    GL.deleteShader(fragShader)
    return shaderProgram
  }
}

class VertexIndices{
  construct new(buffer, count){
    init_(buffer, count)
  }
  construct fromList(list){
    var buffer = GL.createBuffer()
    GL.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, buffer)
    GL.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, Uint16Array.fromList(list), BufferHint.STATIC_DRAW)
    init_(buffer, list.count)
  }

  init_(buffer, count){
    _buffer = buffer
    _count = count
  }

  draw(){
    GL.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, _buffer)
    GL.drawElements(PrimitveType.TRIANGLES, _count, DataType.UNSIGNED_SHORT, 0)
  }
}

class VertexAttribute{
  construct new(buffer, location, components, dataType, normalized, stride, offset){
    init_(buffer, location, components, dataType, normalized, stride, offset)  
  }
  construct fromList(location, components, list){
    var buffer = GL.createBuffer()
    GL.bindBuffer(BufferType.ARRAY_BUFFER, buffer)
    GL.bufferData(BufferType.ARRAY_BUFFER, FloatArray.fromList(list), BufferHint.STATIC_DRAW)
    init_(buffer, location, components, DataType.FLOAT, false, 0, 0)
  }

  init_(buffer, location, components, dataType, normalized, stride, offset){
    _buffer = buffer
    _location = location
    _components = components
    _dataType = dataType
    _normalized = normalized
    _stride = stride
    _offset = offset
  }

  enable(){
    GL.bindBuffer(BufferType.ARRAY_BUFFER, _buffer)
    GL.vertexAttribPointer(_location, _components, _dataType, _normalized, _stride, _offset)
    GL.enableVertexAttribArray(_location)
  }
}