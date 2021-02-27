
// #define GL_([^\s]+)\s+([0-9,A-F,x]+)
class ClearFlag {
  static DEPTH_BUFFER_BIT { 0x00000100 }
  static STENCIL_BUFFER_BIT { 0x00000400 }
  static COLOR_BUFFER_BIT { 0x00004000 }
}

class EnableCap {
  static TEXTURE_2D { 0x0DE1 }
  static CULL_FACE { 0x0B44 }
  static BLEND { 0x0BE2 }
  static DITHER { 0x0BD0 }
  static STENCIL_TEST { 0x0B90 }
  static DEPTH_TEST { 0x0B71 }
  static SCISSOR_TEST { 0x0C11 }
  static POLYGON_OFFSET_FILL { 0x8037 }
  static SAMPLE_ALPHA_TO_COVERAGE { 0x809E }
  static SAMPLE_COVERAGE { 0x80A0 }
}

class BlendFacDst {
  static ZERO { 0 }
  static ONE { 1 }
  static SRC_COLOR { 0x0300 }
  static ONE_MINUS_SRC_COLOR { 0x0301 }
  static SRC_ALPHA { 0x0302 }
  static ONE_MINUS_SRC_ALPHA { 0x0303 }
  static DST_ALPHA { 0x0304 }
  static ONE_MINUS_DST_ALPHA { 0x0305 }
}

class BlendFacSrc {
  static ZERO { 0 }
  static ONE { 1 }
  static DST_COLOR { 0x0306 }
  static ONE_MINUS_DST_COLOR { 0x0307 }
  static SRC_ALPHA_SATURATE { 0x0308 }
  static SRC_ALPHA { 0x0302 }
  static ONE_MINUS_SRC_ALPHA { 0x0303 }
  static DST_ALPHA { 0x0304 }
  static ONE_MINUS_DST_ALPHA { 0x0305 }
}

class ErrorCode {
  static getString(err){
    if(err == ErrorCode.NO_ERROR) return "NO_ERROR"
    if(err == ErrorCode.INVALID_ENUM) return "INVALID_ENUM"
    if(err == ErrorCode.INVALID_VALUE) return "INVALID_VALUE"
    if(err == ErrorCode.INVALID_OPERATION) return "INVALID_OPERATION"
    if(err == ErrorCode.OUT_OF_MEMORY) return "OUT_OF_MEMORY"
  }
  static NO_ERROR { 0 }
  static INVALID_ENUM { 0x0500 }
  static INVALID_VALUE { 0x0501 }
  static INVALID_OPERATION { 0x0502 }
  static OUT_OF_MEMORY { 0x0505 }
}

class BufferType {
  static ARRAY_BUFFER { 0x8892 }
  static ELEMENT_ARRAY_BUFFER { 0x8893 }
}

class BufferHint {
  static STREAM_DRAW { 0x88E0 }
  static STATIC_DRAW { 0x88E4 }
  static DYNAMIC_DRAW { 0x88E8 }
}

class ShaderType {
  static FRAGMENT_SHADER { 0x8B30 }
  static VERTEX_SHADER { 0x8B31 }
}

class DataType {
  static bytes(type){
    if(type == DataType.BYTE || type == DataType.UNSIGNED_BYTE) return 1
    if(type == DataType.SHORT || type == DataType.UNSIGNED_SHORT) return 2
    if(type == DataType.INT || type == DataType.UNSIGNED_INT || type == DataType.FLOAT || type == DataType.FIXED) return 4
  }
  static BYTE { 0x1400 }
  static UNSIGNED_BYTE { 0x1401 }
  static SHORT { 0x1402 }
  static UNSIGNED_SHORT { 0x1403 }
  static INT { 0x1404 }
  static UNSIGNED_INT { 0x1405 }
  static FLOAT { 0x1406 }
  static FIXED { 0x140C }
}

class PixelType {
  static UNSIGNED_BYTE { 0x1401 }
  static UNSIGNED_SHORT_4_4_4_4 { 0x8033 }
  static UNSIGNED_SHORT_5_5_5_1 { 0x8034 }
  static UNSIGNED_SHORT_5_6_5 { 0x8363 }
}

class PixelFormat {
  static components(type){
    if(type == PixelFormat.ALPHA || type == PixelFormat.LUMINANCE) return 1
    if(type == PixelFormat.LUMINANCE_ALPHA) return 2
    if(type == PixelFormat.RGB) return 3
    if(type == PixelFormat.RGBA) return 4
  }
  static ALPHA { 0x1906 }
  static RGB { 0x1907 }
  static RGBA { 0x1908 }
  static LUMINANCE { 0x1909 }
  static LUMINANCE_ALPHA { 0x190A }
}

class PrimitveType {
  static POINTS { 0x0000 }
  static LINES { 0x0001 }
  static LINE_LOOP { 0x0002 }
  static LINE_STRIP { 0x0003 }
  static TRIANGLES { 0x0004 }
  static TRIANGLE_STRIP { 0x0005 }
  static TRIANGLE_FAN { 0x0006 }
}

class ShaderParam {
  static SHADER_TYPE { 0x8B4F }
  static DELETE_STATUS { 0x8B80 }
  static VALIDATE_STATUS { 0x8B83 }
  static COMPILE_STATUS { 0x8B81 }
  static INFO_LOG_LENGTH { 0x8B84 }
  static SHADER_SOURCE_LENGTH { 0x8B88 }
}

class ProgramParam {
  static INFO_LOG_LENGTH { 0x8B84 }
  static DELETE_STATUS { 0x8B80 }
  static LINK_STATUS { 0x8B82 }
  static ATTACHED_SHADERS { 0x8B85 }
  static ACTIVE_UNIFORMS { 0x8B86 }
  static ACTIVE_UNIFORM_MAX_LENGTH { 0x8B87 }
  static ACTIVE_ATTRIBUTES { 0x8B89 }
  static ACTIVE_ATTRIBUTE_MAX_LENGTH { 0x8B8A }
}

class TextureParam {
  static TEXTURE_MAG_FILTER { 0x2800 }
  static TEXTURE_MIN_FILTER { 0x2801 }
  static TEXTURE_WRAP_S { 0x2802 }
  static TEXTURE_WRAP_T { 0x2803 }
}

class TextureWrapMode {
  static REPEAT { 0x2901 }
  static CLAMP_TO_EDGE { 0x812F }
  static MIRRORED_REPEAT { 0x8370 }
}

class TextureMagFilter {
  static NEAREST { 0x2600 }
  static LINEAR { 0x2601 }
}

class TextureMinFilter {
  static NEAREST { 0x2600 }
  static LINEAR { 0x2601 }
  static NEAREST_MIPMAP_NEAREST { 0x2700 }
  static LINEAR_MIPMAP_NEAREST { 0x2701 }
  static NEAREST_MIPMAP_LINEAR { 0x2702 }
  static LINEAR_MIPMAP_LINEAR { 0x2703 }
}

class TextureTarget {
  static TEXTURE_2D { 0x0DE1 }
  static GL_TEXTURE_CUBE_MAP { 0x8513 }
}

class TextureUnit {
  static TEXTURE0 { 0x84C0 }
  static TEXTURE1 { 0x84C1 }
  static TEXTURE2 { 0x84C2 }
  static TEXTURE3 { 0x84C3 }
  static TEXTURE4 { 0x84C4 }
  static TEXTURE5 { 0x84C5 }
  static TEXTURE6 { 0x84C6 }
  static TEXTURE7 { 0x84C7 }
  static TEXTURE8 { 0x84C8 }
  static TEXTURE9 { 0x84C9 }
  static TEXTURE10 { 0x84CA }
  static TEXTURE11 { 0x84CB }
  static TEXTURE12 { 0x84CC }
  static TEXTURE13 { 0x84CD }
  static TEXTURE14 { 0x84CE }
  static TEXTURE15 { 0x84CF }
  static TEXTURE16 { 0x84D0 }
  static TEXTURE17 { 0x84D1 }
  static TEXTURE18 { 0x84D2 }
  static TEXTURE19 { 0x84D3 }
  static TEXTURE20 { 0x84D4 }
  static TEXTURE21 { 0x84D5 }
  static TEXTURE22 { 0x84D6 }
  static TEXTURE23 { 0x84D7 }
  static TEXTURE24 { 0x84D8 }
  static TEXTURE25 { 0x84D9 }
  static TEXTURE26 { 0x84DA }
  static TEXTURE27 { 0x84DB }
  static TEXTURE28 { 0x84DC }
  static TEXTURE29 { 0x84DD }
  static TEXTURE30 { 0x84DE }
  static TEXTURE31 { 0x84DF }
}

class FramebufferTarget {
  static FRAMEBUFFER { 0x8D40 }
  static RENDERBUFFER { 0x8D41 }
}

class FramebufferAttachment {
  static COLOR_ATTACHMENT0 { 0x8CE0 }
  static DEPTH_ATTACHMENT { 0x8D00 }
  static STENCIL_ATTACHMENT { 0x8D20 }
}

class FramebufferStatus {
  static FRAMEBUFFER_COMPLETE { 0x8CD5 }
  static FRAMEBUFFER_INCOMPLETE_ATTACHMENT { 0x8CD6 }
  static FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT { 0x8CD7 }
  static FRAMEBUFFER_INCOMPLETE_DIMENSIONS { 0x8CD9 }
  static FRAMEBUFFER_UNSUPPORTED { 0x8CDD }
}

foreign class GlShader {}
foreign class GlProgram {}
foreign class GlBuffer {}
foreign class GlTexture {}
foreign class GlFramebuffer {}

class GL {
  foreign static clear(clearflags)
  foreign static clearColor(r,g,b,a)
  foreign static enable(enableCap)
  foreign static disable(enableCap)
  foreign static blendFunc(blendfacsrc, blendfacdst)
  foreign static getError()
  foreign static viewport(x,y,w,h)

  static createBuffer() { createBuffer(GlBuffer) }
  foreign static createBuffer(fclass)
  foreign static bindBuffer(type, glBuffer)
  static bufferData(type, buffer, usageHint) { bufferData(type, buffer.buffer, buffer.offset, buffer.size, usageHint) }
  foreign static bufferData(type, buffer, offset, size, usageHint)
  static bufferSubData(type, offset, size, buffer) { bufferSubData(type, offset, size, buffer.buffer, buffer.offset, buffer.size) }
  foreign static bufferSubData(type, offset, size, buffer, srcOffset, srcSize)

  static createShader(type) { createShader(type, GlShader) }
  foreign static createShader(type, fclass)
  foreign static shaderSource(shader, source)
  foreign static compileShader(shader)
  foreign static getShaderParameter(shader, shaderParam)
  foreign static getShaderInfoLog(shader)
  foreign static deleteShader(shader)

  static createProgram() { createProgram(GlProgram) }
  foreign static createProgram(fclass)
  foreign static attachShader(program, shader)
  foreign static linkProgram(program)
  foreign static useProgram(program)
  foreign static getProgramParameter(program, programParam)
  foreign static getProgramInfoLog(program)
  foreign static deleteProgram(program)

  foreign static getAttribLocation(program, name)
  foreign static vertexAttribPointer(location, size, type, normalized, stride, offset)
  foreign static enableVertexAttribArray(location)
  foreign static getUniformLocation(program, name)
  foreign static uniform1i(location, x)
  foreign static uniform2i(location, x, y)
  foreign static uniform3i(location, x, y, z)
  foreign static uniform4i(location, x, y, z, w)
  foreign static uniform1f(location, x)
  foreign static uniform2f(location, x, y)
  foreign static uniform3f(location, x, y, z)
  foreign static uniform4f(location, x, y, z, w)

  foreign static drawElements(mode, count, type, offset)

  static createTexture() { createTexture(GlTexture) }
  foreign static createTexture(fclass)
  foreign static bindTexture(type, texture)
  static texImage2D(type, level, internalFormat, width, height, border, srcFormat, srcType, buffer) { texImage2D(type, level, internalFormat, width, height, border, srcFormat, srcType, buffer.buffer, buffer.offset, width * height * DataType.bytes(srcType) * PixelFormat.components(srcFormat)) }
  static texImage2D(type, level, internalFormat, width, height, border, srcFormat, srcType) { texImage2D(type, level, internalFormat, width, height, border, srcFormat, srcType, null, 0, 0) }
  foreign static texImage2D(type, level, internalFormat, width, height, border, srcFormat, srcType, buffer, offset, size)
  static texSubImage2D(type, level, xoffset, yoffset, width, height, format, dataType, buffer) { texSubImage2D(type, level, xoffset, yoffset, width, height, format, dataType, buffer.buffer, buffer.offset, width * height * DataType.bytes(dataType) * PixelFormat.components(format)) }
  foreign static texSubImage2D(type, level, xoffset, yoffset, width, height, format, dataType, buffer, offset, size)
  foreign static generateMipmap(type)
  foreign static texParameteri(type, parameterType, parameterValue)
  foreign static activeTexture(texUnit)

  static createFramebuffer() { createFramebuffer(GlFramebuffer) }
  foreign static createFramebuffer(fclass)
  foreign static bindFramebuffer(target, buffer)
  foreign static framebufferTexture2D(target, attachmentPoint, textureTarget, texture, level)
  foreign static checkFramebufferStatus(target)
}